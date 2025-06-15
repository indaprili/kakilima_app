// lib/qris_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

List<CameraDescription> _cameras = [];

class QrisScannerPage extends StatefulWidget {
  const QrisScannerPage({super.key});

  @override
  State<QrisScannerPage> createState() => _QrisScannerPageState();
}

class _QrisScannerPageState extends State<QrisScannerPage> {
  CameraController? _cameraController;
  Future<void>? _initializeCameraControllerFuture;
  bool _isCameraInitialized = false;
  bool _hasPermission = false;
  bool _isFlashOn = false;
  String _scannedQrCode = '';
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _checkCameraPermissionAndInitialize();
  }

  Future<void> _checkCameraPermissionAndInitialize() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _hasPermission = true);
      _initializeCamera();
    } else {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() => _hasPermission = true);
        _initializeCamera();
      } else {
        setState(() => _hasPermission = false);
        _showPermissionDeniedDialog();
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }

      if (_cameras.isEmpty) {
        throw Exception('No cameras found on device.');
      }

      final backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeCameraControllerFuture = _cameraController!
          .initialize()
          .then((_) {
            if (!mounted) return;
            setState(() {
              _isCameraInitialized = true;
              _isFlashOn =
                  _cameraController?.value.flashMode == FlashMode.torch;
            });
          })
          .catchError((e) {
            print("Error initializing camera: $e");
            setState(() {
              _isCameraInitialized = false;
              _hasPermission = false;
            });
            _showErrorDialog(
              "Gagal menginisialisasi kamera. Mungkin aplikasi lain sedang menggunakannya atau ada masalah lain.",
            );
          });
    } catch (e) {
      print("Error getting available cameras: $e");
      setState(() => _hasPermission = false);
      _showErrorDialog("Tidak ada kamera tersedia atau terjadi kesalahan: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Terjadi Kesalahan', style: GoogleFonts.poppins()),
            content: Text(message, style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Izin Kamera Dibutuhkan', style: GoogleFonts.poppins()),
            content: Text(
              'Aplikasi ini memerlukan akses kamera untuk memindai kode QR. Mohon berikan izin di pengaturan aplikasi Anda.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: Text('Buka Pengaturan', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      print("Error toggling flash: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengubah flash: $e')));
    }
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_cameras.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hanya ada satu kamera tersedia')),
      );
      return;
    }

    CameraDescription newCamera;
    if (_cameraController!.description.lensDirection ==
        CameraLensDirection.back) {
      newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } else {
      newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
    }

    await _cameraController!.dispose();
    _cameraController = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeCameraControllerFuture = _cameraController!
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {
            _isFlashOn = _cameraController?.value.flashMode == FlashMode.torch;
          });
        })
        .catchError((e) {
          print("Error switching camera: $e");
          _showErrorDialog("Gagal beralih kamera: $e");
        });
  }

  Future<String?> _takePicture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile file = await _cameraController!.takePicture();
      print('Picture saved to: ${file.path}');
      return file.path;
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Scan QRIS', style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF7B2CBF),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Izin kamera tidak diberikan.',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _checkCameraPermissionAndInitialize,
                child: Text('Coba Lagi', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QRIS', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF7B2CBF),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _isCameraInitialized) {
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController!),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.black54,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _scannedQrCode.isEmpty
                              ? 'Arahkan kamera ke kode QRIS (Demo)'
                              : 'QR Code Terdeteksi:',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        if (_scannedQrCode.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _scannedQrCode,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              color: Colors.white,
                              icon: Icon(
                                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                size: 32,
                              ),
                              onPressed: _toggleFlash,
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(
                                _cameraController?.description.lensDirection ==
                                        CameraLensDirection.back
                                    ? Icons.camera_rear
                                    : Icons.camera_front,
                                size: 32,
                              ),
                              onPressed: _switchCamera,
                            ),
                            ElevatedButton.icon(
                              onPressed:
                                  !_isCameraInitialized
                                      ? null
                                      : () async {
                                        final imagePath = await _takePicture();
                                        if (imagePath != null) {
                                          setState(() {
                                            _scannedQrCode =
                                                'Gambar diambil: ${imagePath.split('/').last}';
                                            _isScanning = false;
                                          });
                                        }
                                      },
                              icon: const Icon(Icons.qr_code_scanner),
                              label: Text(
                                'Simulasi Scan',
                                style: GoogleFonts.poppins(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (_scannedQrCode.isNotEmpty)
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _scannedQrCode = '';
                                    _isScanning = true;
                                  });
                                  _initializeCamera();
                                },
                                icon: const Icon(Icons.refresh),
                                label: Text(
                                  'Scan Ulang',
                                  style: GoogleFonts.poppins(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
