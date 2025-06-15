import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'detail.dart';

class KategoriPage extends StatelessWidget {
  KategoriPage({super.key});

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
    },
  ];

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialMapCameraPosition = CameraPosition(
      target: LatLng(-7.250445, 112.768845),
      zoom: 12.0,
    );

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialMapCameraPosition,
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
            builder:
                (context, scrollController) => Container(
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
                                        children:
                                            warteg['images']
                                                .map<Widget>(
                                                  (img) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.0,
                                                          ),
                                                      child: Image.asset(
                                                        img,
                                                        // --- PERUBAHAN DI SINI ---
                                                        width:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.3, // Lebar sekitar 30% dari layar
                                                        // --- AKHIR PERUBAHAN ---
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            width:
                                                                MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.3, // Sesuaikan juga untuk error builder
                                                            color:
                                                                Colors
                                                                    .grey[300],
                                                            child: Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color:
                                                                  Colors
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
                                                color:
                                                    warteg['isOpen']
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
