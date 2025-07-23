import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'full_map_screen.dart';
import 'riwayat_page.dart';
import 'kategori.dart';
import 'pesan_page.dart';
import 'topup_dompet.dart';
import 'favorit_page.dart';
import 'qris_scanner_page.dart';
import 'profile_page.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  // Koordinat awal untuk peta di homepage (contoh: Surabaya)
  final LatLng _initialLocation = const LatLng(-7.2575, 112.7521); // Koordinat Surabaya

  int _selectedIndex = 0;

  late final List<Widget> _actualPageWidgets = <Widget>[
    _buildHomepageContent(), // Indeks 0: Beranda
    const PesanPage(), // Indeks 1: Kotak masuk
    const RiwayatPage(), // Indeks 2: Riwayat (akan dipetakan dari indeks 3 BNB)
    const FavoritPage(), // Indeks 3: Favorit (akan dipetakan dari indeks 4 BNB)
  ];

  int _getPageIndexForIndexedStack(int bottomNavIndex) {
    if (bottomNavIndex == 0) {
      return 0;
    } else if (bottomNavIndex == 1) {
      return 1;
    } else if (bottomNavIndex == 2) {
      return 0; // Tetap tampilkan Beranda di IndexedStack saat Q-RIS aktif
    } else if (bottomNavIndex == 3) {
      return 2;
    } else if (bottomNavIndex == 4) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _getPageIndexForIndexedStack(_selectedIndex),
          children: _actualPageWidgets,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B2CBF),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 2) {
            _navigateToQrisScanner();
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Kotak masuk',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF7B2CBF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            label: 'Q-RIS',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Riwayat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToQrisScanner() async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrisScannerPage()),
    );

    if (scannedData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QRIS berhasil dipindai: $scannedData'),
          duration: const Duration(seconds: 3),
        ),
      );
      print('Data QRIS dari scanner: $scannedData');
    }

    setState(() {
      _selectedIndex = 0;
    });
  }

  Widget _buildHomepageContent() {
    // Hapus: GoogleMapController? contentMapController; // Tidak diperlukan lagi
    // Hapus: final CameraPosition contentKGooglePlex = CameraPosition(...) // Tidak diperlukan lagi
    // Hapus: Future<void> setMapStyle(...) // Tidak diperlukan lagi

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                customBorder: const CircleBorder(),
                child: const Icon(
                  Icons.account_circle,
                  size: 44,
                  color: Color(0xFF7B2CBF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'cari apa?',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Pedagang di dekatmu:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF7B2CBF), width: 3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Ganti GoogleMap dengan FlutterMap
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _initialLocation, // Pusat peta di Surabaya
                      initialZoom: 13.0, // Zoom awal untuk peta mini
                      // Anda bisa membatasi interaksi jika ini hanya peta mini
                      // interactionOptions: const InteractionOptions(
                      //   flags: InteractiveFlag.all & ~InteractiveFlag.rotate, // Contoh: disable rotasi
                      // ),
                      // Batas area yang bisa digulir
                      // maxBounds parameter removed because it is not supported in MapOptions
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.kakilima_app', // Pastikan sesuai package name Anda
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _initialLocation, // Marker di lokasi awal (Surabaya)
                            width: 80.0,
                            height: 80.0,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                          // Anda bisa menambahkan marker lain di sini jika ada lokasi pedagang
                          // Marker(
                          //   point: LatLng(-7.2500, 112.7700), // Contoh pedagang lain
                          //   width: 80,
                          //   height: 80,
                          //   child: Icon(Icons.store, color: Colors.blue, size: 30),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            // Pastikan FullMapScreen sudah diupdate untuk menggunakan LatLng dari latlong2
                            // dan tidak lagi menerima parameter 'center' jika Anda ingin selalu di Surabaya
                            MaterialPageRoute(builder: (context) => FullMapScreen()), // Panggil tanpa 'center'
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Lihat peta KakiLima',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopupDompetPage()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 39,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 96, 13, 169),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Color(0x4C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wallet, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Dompet saya',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Rp',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '100.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kategori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: [
              _buildCategoryItem(Icons.storefront, 'Pedagang\nKaki lima'),
              _buildCategoryItem(Icons.restaurant, 'Warteg'),
              _buildCategoryItem(Icons.local_cafe, 'Warung\nKopi'),
              _buildCategoryItem(Icons.local_dining, 'Angkringan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return InkWell(
      onTap: () {
        if (label.contains('Warteg')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KategoriPage()),
          );
        } else {
          print('Kategori $label dipencet');
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF7B2CBF)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}