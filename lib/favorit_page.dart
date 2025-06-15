import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  static const List<Map<String, String>> favoriteList = [
    {
      "title": "Warteg Bahari",
      "subtitle": "Warteg",
      "distance": "950m",
      "rating": "4.8",
      "image": "assets/warteg_bahari1.jpg",
    },
    {
      "title": "Bakso Mang Ujang",
      "subtitle": "Pedagang kaki lima",
      "distance": "2.3km",
      "rating": "4.0",
      "image":
          "https://your-image-url.com/bakso1.jpg", // Pastikan URL ini valid
    },
    {
      "title": "Bakso Mang Ujang",
      "subtitle": "Pedagang kaki lima",
      "distance": "2.1km",
      "rating": "4.0",
      "image":
          "https://your-image-url.com/bakso2.jpg", // Pastikan URL ini valid
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FavoritKu", style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true, // Menempatkan judul di tengah
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteList.length,
        itemBuilder: (context, index) {
          final item = favoriteList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    child: Image.network(
                      item['image']!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['subtitle']!,
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['distance']!,
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['rating']!,
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Icon(Icons.favorite, color: Colors.purple),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/info',
                              arguments: item,
                            );
                          },
                          child: Text(
                            "Lihat",
                            style: GoogleFonts.poppins(color: Colors.white),
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
    );
  }
}
