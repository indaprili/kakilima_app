// lib/rating_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingPage extends StatefulWidget {
  final String wartegName;

  const RatingPage({super.key, required this.wartegName});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  // Map to store ratings for each category
  final Map<String, int> _categoryRatings = {
    'Suasana': 0,
    'Pelayanan': 0,
    'Harga': 0,
    'Rasa': 0,
  };

  // Map to track which category's rating section is expanded
  final Map<String, bool> _isCategoryExpanded = {
    'Suasana': false,
    'Pelayanan': false,
    'Harga': false,
    'Rasa': false,
  };

  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Helper widget for star rating input
  Widget _buildStarRatingInput(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _categoryRatings[category]!
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
            size: 36,
          ),
          onPressed: () {
            setState(() {
              _categoryRatings[category] = index + 1;
            });
          },
        );
      }),
    );
  }

  // Method to check if at least one rating has been given
  bool _areAnyRatingsGiven() {
    return _categoryRatings.values.any((rating) => rating > 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beri Penilaian untuk ${widget.wartegName}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Jenis Penilaian',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Suasana Category
            _buildExpandableCategoryTile('Suasana'),
            if (_isCategoryExpanded['Suasana']!)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildStarRatingInput('Suasana'),
              ),

            // Pelayanan Category
            _buildExpandableCategoryTile('Pelayanan'),
            if (_isCategoryExpanded['Pelayanan']!)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildStarRatingInput('Pelayanan'),
              ),

            // Harga Category
            _buildExpandableCategoryTile('Harga'),
            if (_isCategoryExpanded['Harga']!)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildStarRatingInput('Harga'),
              ),

            // Rasa Category
            _buildExpandableCategoryTile('Rasa'),
            if (_isCategoryExpanded['Rasa']!)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildStarRatingInput('Rasa'),
              ),

            // =======================================================
            // Perubahan dimulai di sini:
            // Bagian ini hanya akan muncul jika setidaknya satu rating diberikan
            if (_areAnyRatingsGiven()) ...[
              const SizedBox(height: 24),
              Text(
                'Tulis Ulasanmu',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Bagaimana pengalamanmu di ${widget.wartegName}?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validasi sudah dipindahkan ke sini, tapi masih bisa dipakai
                    // untuk mencegah submission jika user somehow kembali ke 0 rating
                    // dan mencoba submit.
                    if (!_areAnyRatingsGiven()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Harap berikan setidaknya satu rating kategori sebelum mengirim ulasan.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // If validation passes, proceed with submission
                    print('Suasana Rating: ${_categoryRatings['Suasana']}');
                    print('Pelayanan Rating: ${_categoryRatings['Pelayanan']}');
                    print('Harga Rating: ${_categoryRatings['Harga']}');
                    print('Rasa Rating: ${_categoryRatings['Rasa']}');
                    print('Review: ${_reviewController.text}');

                    // You would typically send this data to a backend
                    Navigator.pop(context); // Go back to the detail page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Terima kasih atas penilaian Anda untuk ${widget.wartegName}!',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B2CBF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Kirim Penilaian',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            // Perubahan berakhir di sini
            // =======================================================
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCategoryTile(String category) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        title: Text(
          category,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display current star rating if rating is > 0, regardless of expansion state
            if (_categoryRatings[category]! > 0) ...[
              ...List.generate(5, (index) {
                return Icon(
                  index < _categoryRatings[category]!
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
              const SizedBox(width: 8),
            ],
            Icon(
              _isCategoryExpanded[category]!
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
        onTap: () {
          setState(() {
            // Toggle the expansion state for the tapped category
            _isCategoryExpanded[category] = !_isCategoryExpanded[category]!;

            // Optionally, collapse other categories when one is expanded
            _isCategoryExpanded.forEach((key, value) {
              if (key != category) {
                _isCategoryExpanded[key] = false;
              }
            });
          });
        },
      ),
    );
  }
}
