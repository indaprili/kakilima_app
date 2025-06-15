import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class TopupDompetPage extends StatelessWidget {
  const TopupDompetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan path aset lokal untuk logo, langsung di dalam folder assets/
    final bankTransfer = [
      {
        "label": "BANK BRI",
        "account": "123 456 7890",
        "logo": "bri.png", // Path disesuaikan: assets/nama_file.png
      },
      {
        "label": "BCA",
        "account": "098 765 4321",
        "logo": "bca.png", // Path disesuaikan
      },
      {
        "label": "Mandiri",
        "account": "111 222 3333",
        "logo": "mandiri.png", // Path disesuaikan
      },
      {
        "label": "Maybank",
        "account": "555 999 8888",
        "logo": "maybank.png", // Path disesuaikan
      },
      {
        "label": "Bank lain",
        "account": "000 000 0000",
        "logo": "bank.png", // Path disesuaikan
      },
    ];

    final cashOptions = [
      {
        "label": "Indomaret",
        "account": "Kode: 00123",
        "logo": "indomaret.png", // Path disesuaikan
      },
      {
        "label": "Alfamart",
        "account": "Kode: 00456",
        "logo": "alfamart.png", // Path disesuaikan
      },
      {
        "label": "LAWSON",
        "account": "Kode: 00789",
        "logo": "lawson.png", // Path disesuaikan
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up Dompet', style: GoogleFonts.poppins()),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Apa yang ingin kamu gunakan?",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Bank Transfer",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCard(context, bankTransfer),
            const SizedBox(height: 24),
            Text(
              "Cash",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCard(context, cashOptions),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Map<String, String>> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children:
            items.map((item) {
              return ListTile(
                leading: Image.asset(
                  // Menggunakan Image.asset
                  item['logo']!,
                  height: 40,
                  width: 40,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.error),
                ),
                title: Text(item['label']!, style: GoogleFonts.poppins()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showBankDialog(
                    context,
                    item['label']!,
                    item['account']!,
                    item['logo']!,
                  );
                },
              );
            }).toList(),
      ),
    );
  }

  void _showBankDialog(
    BuildContext context,
    String label,
    String account,
    String logo,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  logo,
                  height: 48,
                ), // Menggunakan Image.asset di sini
                const SizedBox(height: 12),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Nomor Rekening",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                Text(
                  account,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: account));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nomor rekening disalin")),
                    );
                  },
                  child: Text(
                    "Salin",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
