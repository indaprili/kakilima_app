import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  static const Map<String, IconData> _riwayatIcons = {
    "59370": Icons.location_on,
    "59509": Icons.star,
    "59658": Icons.account_balance_wallet,
    "57429": Icons.add_circle,
    "58711": Icons.cancel,
  };

  final List<Map<String, String?>> riwayatTransaksi = const [
    {
      "keterangan": "Mengunjungi Warteg Bahari",
      "tanggal": "12/04/2025",
      "status": "Berhasil",
      "nominal": "",
      "icon": "59370",
    },
    {
      "keterangan": "Memberikan penilaian ke Angkringan Tujuhbelas",
      "tanggal": "10/04/2025",
      "status": "Berhasil",
      "nominal": "",
      "icon": "59509",
    },
    {
      "keterangan": "Melakukan transaksi menggunakan Dompet KakiLima sebesar",
      "tanggal": "08/04/2025",
      "status": "Berhasil",
      "nominal": "Rp17.500",
      "icon": "59658",
    },
    {
      "keterangan": "Melakukan top up sebesar",
      "tanggal": "06/04/2025",
      "status": "Berhasil",
      "nominal": "Rp30.000",
      "icon": "57429",
    },
    {
      "keterangan": "Gagal melakukan top up",
      "tanggal": "04/04/2025",
      "status": "Gagal",
      "nominal": "Rp50.000",
      "icon": "58711",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'), // Teks judul "Riwayat"
        centerTitle: true, // Opsional: untuk menempatkan judul di tengah
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: ListView.builder(
        itemCount: riwayatTransaksi.length,
        itemBuilder: (context, index) {
          final transaksi = riwayatTransaksi[index];
          final IconData leadingIcon =
              _riwayatIcons[transaksi['icon']] ?? Icons.error;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                leadingIcon,
                color:
                    transaksi['status'] == 'Berhasil'
                        ? Colors.green
                        : Colors.red,
              ),
              title: Text(
                transaksi['keterangan'] ?? 'Keterangan tidak tersedia',
              ),
              subtitle: Text(
                '${transaksi['tanggal']} - ${transaksi['nominal'] ?? ''}',
              ),
              trailing: Icon(
                transaksi['status'] == 'Berhasil'
                    ? Icons.check_circle
                    : Icons.cancel,
                color:
                    transaksi['status'] == 'Berhasil'
                        ? Colors.green
                        : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
