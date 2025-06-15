// detail.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import for GoogleFonts
import 'rating_page.dart'; // Import the new rating page

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> warteg;

  const DetailPage({super.key, required this.warteg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          warteg['name'],
          style: GoogleFonts.poppins(),
        ), // Use GoogleFonts
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    warteg['images']
                        .map<Widget>(
                          (img) => Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              img,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.broken_image,
                                  ), // Add error builder
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.circle, size: 10, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  "Buka — ${warteg['distance']}",
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            Text(
              '(${warteg['rating']}/5) ${warteg['price']}',
              style: GoogleFonts.poppins(color: Colors.orange),
            ),
            const Divider(),
            _infoRow(Icons.location_on, warteg['address']),
            _infoRow(Icons.attach_money, warteg['avgPrice']),
            _infoRow(Icons.access_time, warteg['hours']),
            _infoRow(Icons.phone, warteg['phone']),
            const Divider(),
            Text(
              "Penilaian",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${warteg['rating']} / 5',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...warteg['reviews'].map<Widget>(
              (r) => ListTile(
                leading: const CircleAvatar(),
                title: Text(r['name'], style: GoogleFonts.poppins()),
                subtitle: Text(r['comment'], style: GoogleFonts.poppins()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the RatingPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => RatingPage(
                          wartegName: warteg['name'],
                        ), // Pass warteg name
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B2CBF),
              ), // Using the color you have
              child: Text(
                "Kasih Penilaian",
                style: GoogleFonts.poppins(color: Colors.white),
              ), // Set text color to white
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins())),
        ],
      ),
    );
  }
}
