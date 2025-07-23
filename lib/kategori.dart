import 'package:flutter/material.dart';
// Hapus: import 'package:Maps_flutter/Maps_flutter.dart'; // Hapus ini

// Tambahkan import ini untuk OpenStreetMap
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'detail.dart';

class KategoriPage extends StatelessWidget {
  KategoriPage({super.key});

  // Contoh data warteg. Anda bisa menambahkan koordinat di sini jika ingin menandai mereka di peta.
  final List<Map<String, dynamic>> wartegList = [
    {
      'name': 'Warteg Bahari',
      'rating': 4.8,
      'price': 'Rp. 3.000 - 20.000',
      'distance': '500m',
      'isOpen': true,
      'images': [
        'assets/warteg_bahari1.jpg',
        'assets/warteg_bahari2.jpg',
        'assets/warteg_bahari3.jpg',
      ],
      'address': 'Arief Rahman Hakim, Keputih, Surabaya',
      'avgPrice': 'Rp 1–25.000',
      'hours': '06.00–21.00',
      'phone': '0812-3456-7891',
      'reviews': [
        {
          'name': 'User 1',
          'comment': 'Tempat andalan anak kos nih.',
          'rating': 5,
        },
        {
          'name': 'User 2',
          'comment': 'Langganan karena enak dan murah.',
          'rating': 5,
        },
      ],
      'latitude': -7.2800, // Tambahkan koordinat untuk Warteg Bahari
      'longitude': 112.7900,
    },
    {
      'name': 'Warteg Cak Mat',
      'rating': 4.3,
      'price': 'Rp. 4.000 - 18.000',
      'distance': '800m',
      'isOpen': true,
      'images': ['assets/warteg_cakmat1.jpg', 'assets/warteg_cakmat2.jpg'],
      'address': 'Jl. Teknik Kimia No. 10, Surabaya',
      'avgPrice': 'Rp 4–20.000',
      'hours': '07.00–20.00',
      'phone': '0813-1234-5678',
      'reviews': [
        {'name': 'User A', 'comment': 'Sambalnya mantap!', 'rating': 4},
      ],
      'latitude': -7.2650, // Tambahkan koordinat untuk Warteg Cak Mat
      'longitude': 112.7800,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Koordinat pusat peta (misalnya, pusat Surabaya)
    final LatLng initialMapCenter = LatLng(-7.2575, 112.7521);

    // Kumpulan marker dari daftar warteg
    List<Marker> wartegMarkers = wartegList.map((warteg) {
      return Marker(
        point: LatLng(warteg['latitude'], warteg['longitude']),
        width: 80.0,
        height: 80.0,
        child: GestureDetector(
          onTap: () {
            // Logika ketika marker diklik, misalnya menampilkan info warteg
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Anda mengklik ${warteg['name']}')),
            );
          },
          child: const Icon(
            Icons.location_on,
            color: Colors.blue, // Warna ikon marker warteg
            size: 40.0,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          // Ganti SizedBox yang berisi GoogleMap
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: FlutterMap( // Gunakan FlutterMap
              options: MapOptions(
                initialCenter: initialMapCenter, // Pusat peta di Surabaya
                initialZoom: 12.0, // Level zoom awal
              ),
              children: [
                TileLayer( // Layer untuk ubin peta OpenStreetMap
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.kakilima_app', // Pastikan ini sesuai dengan package name Anda
                ),
                MarkerLayer( // Layer untuk menampilkan marker warteg
                  markers: wartegMarkers,
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Warteg',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, scrollController) => Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Icon(Icons.tune, color: Colors.purple),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text("Buka"),
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text("Terdekat"),
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text("Termurah"),
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text("Rating tertinggi"),
                          onSelected: (_) {},
                          
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: wartegList.length,
                      itemBuilder: (context, index) {
                        final warteg = wartegList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(warteg: warteg),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: warteg['images']
                                        .map<Widget>(
                                          (img) => Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8.0),
                                              child: Image.asset(
                                                img,
                                                width: MediaQuery.of(
                                                        context)
                                                    .size
                                                    .width *
                                                    0.3,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    width: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width *
                                                        0.3,
                                                    color:
                                                        Colors.grey[300],
                                                    child: Icon(
                                                      Icons
                                                          .broken_image,
                                                      color: Colors
                                                          .grey[600],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        warteg['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: warteg['isOpen']
                                                ? Colors.orange
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            warteg['isOpen']
                                                ? 'Buka'
                                                : 'Tutup',
                                          ),
                                          const SizedBox(width: 10),
                                          Text('— ${warteg['distance']}'),
                                        ],
                                      ),
                                      Text(
                                        '(${warteg['rating']}/5) ${warteg['price']}',
                                        style: const TextStyle(
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}