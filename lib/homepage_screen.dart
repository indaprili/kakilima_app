import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'full_map_screen.dart';
import 'riwayat_page.dart';
import 'kategori.dart';
import 'pesan_page.dart';
import 'topup_dompet.dart';
import 'favorit_page.dart';
import 'qris_scanner_page.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final LatLng _initialLocation = const LatLng(-7.250445, 112.768845);
  // _selectedIndex sekarang akan langsung mencerminkan indeks BottomNavigationBar yang sedang aktif
  int _selectedIndex = 0;

  // Daftar widget halaman yang sebenarnya akan ditampilkan di IndexedStack.
  // Q-RIS tidak ada di sini karena akan navigasi ke halaman terpisah.
  late final List<Widget> _actualPageWidgets = <Widget>[
    _buildHomepageContent(), // Indeks 0: Beranda
    const PesanPage(), // Indeks 1: Kotak masuk
    const RiwayatPage(), // Indeks 2: Riwayat (akan dipetakan dari indeks 3 BNB)
    const FavoritPage(), // Indeks 3: Favorit (akan dipetakan dari indeks 4 BNB)
  ];

  // Fungsi bantu untuk mendapatkan indeks halaman yang benar untuk IndexedStack
  // berdasarkan indeks yang dipilih di BottomNavigationBar.
  int _getPageIndexForIndexedStack(int bottomNavIndex) {
    if (bottomNavIndex == 0) {
      // Beranda (BNB index 0)
      return 0; // -> _actualPageWidgets[0]
    } else if (bottomNavIndex == 1) {
      // Kotak masuk (BNB index 1)
      return 1; // -> _actualPageWidgets[1]
    } else if (bottomNavIndex == 2) {
      // Q-RIS (BNB index 2) - ini adalah tombol navigasi, bukan halaman di IndexedStack
      // Jika tombol Q-RIS ditekan, kita tidak menampilkan halaman baru di IndexedStack.
      // Kita akan menavigasi ke halaman QrisScannerPage.
      // Untuk tujuan tampilan IndexedStack sementara, kita bisa kembali ke Beranda (index 0).
      return 0; // Tetap tampilkan Beranda di IndexedStack saat Q-RIS aktif
    } else if (bottomNavIndex == 3) {
      // Riwayat (BNB index 3)
      return 2; // -> _actualPageWidgets[2] (RiwayatPage)
    } else if (bottomNavIndex == 4) {
      // Favorit (BNB index 4)
      return 3; // -> _actualPageWidgets[3] (FavoritPage)
    }
    return 0; // Fallback ke Beranda untuk indeks yang tidak terduga
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // IndexedStack menggunakan indeks yang sudah disesuaikan
        child: IndexedStack(
          index: _getPageIndexForIndexedStack(_selectedIndex),
          children: _actualPageWidgets,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B2CBF),
        unselectedItemColor: Colors.grey,
        currentIndex:
            _selectedIndex, // currentIndex langsung menggunakan _selectedIndex
        onTap: (index) {
          // Selalu perbarui _selectedIndex sesuai dengan indeks yang ditekan
          setState(() {
            _selectedIndex = index;
          });

          // Logika khusus untuk tombol Q-RIS (yang melakukan navigasi terpisah)
          if (index == 2) {
            _navigateToQrisScanner(); // Navigasi ke halaman scanner
          }
          // Untuk tombol lain (Beranda, Kotak masuk, Riwayat, Favorit),
          // _selectedIndex sudah diupdate di setState di atas, dan IndexedStack akan
          // otomatis menampilkan halaman yang benar melalui _getPageIndexForIndexedStack.
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
          // --- Custom Q-RIS Button ---
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -15), // Menggeser ikon ke atas
              child: Container(
                width: 60, // Lebar lingkaran diperbesar
                height: 60, // Tinggi lingkaran diperbesar
                decoration: const BoxDecoration(
                  color: Color(0xFF7B2CBF), // Warna ungu
                  shape: BoxShape.circle, // Bentuk lingkaran
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000), // Bayangan untuk efek terangkat
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 35, // Ukuran ikon diperbesar
                ),
              ),
            ),
            label: 'Q-RIS',
          ),
          // --- End Custom Q-RIS Button ---
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

    // Penting: Setelah kembali dari scanner, kembalikan _selectedIndex ke Beranda (indeks 0)
    // agar highlight BottomNavigationBar kembali ke Beranda.
    setState(() {
      _selectedIndex = 0;
    });
  }

  Widget _buildHomepageContent() {
    GoogleMapController? contentMapController;
    final CameraPosition contentKGooglePlex = CameraPosition(
      target: _initialLocation,
      zoom: 13.0,
    );

    Future<void> setMapStyle(GoogleMapController controller) async {
      String style = await rootBundle.loadString('assets/map_style.json');
      controller.setMapStyle(style);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/profile_image.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.error),
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
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: contentKGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      contentMapController = controller;
                      setMapStyle(controller);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('initialLocation'),
                        position: _initialLocation,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    },
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
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      FullMapScreen(center: _initialLocation),
                            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
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
                    children: const [
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
