import 'package:flutter/material.dart';
import 'chat_detail_page.dart';
import 'notifikasi_page.dart';

class PesanPage extends StatelessWidget {
  const PesanPage({super.key});

  List<Map<String, String>> getAllPedagang() {
    return [
      {
        'name': 'Warteg Bahari',
        'image':
            'https://imgcdn.espos.id/@espos/images/2020/09/14-warteg-1024x768-1.jpg',
        'status': 'Buka • 500m',
        'kategori': 'Warteg',
      },
      {
        'name': 'Warteg Aero',
        'image':
            'https://static.republika.co.id/uploads/member/images/news/241204201925-371.jpg',
        'status': 'Tutup • 350m',
        'kategori': 'Warteg',
      },
      {
        'name': 'Bakso Mang Ujang',
        'image':
            'https://www.masakapahariini.com/wp-content/uploads/2022/03/Bakso-Malang-Mantap.jpg',
        'status': 'Buka • 300m',
        'kategori': 'Pedagang Kaki Lima',
      },
      {
        'name': 'Kopi Nusantara',
        'image':
            'https://images.bisnis.com/posts/2021/02/10/1347035/kafe-balikpapan-supplier-kopi-balikpapan-warkop-nusantara-a.jpg',
        'status': 'Buka • 450m',
        'kategori': 'Warung Kopi',
      },
      {
        'name': 'Warmindo',
        'image':
            'https://www.esb.id/images/article/1739941112_f422ade4985c628ab0dd.jpg',
        'status': 'Buka • 600m',
        'kategori': 'Warung Kopi',
      },
      {
        'name': 'Angkringan Gareng Petruk',
        'image':
            'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/124/2024/01/19/Screenshot_20240119_185110_Gallery-3218645473.jpg',
        'status': 'Buka • 250m',
        'kategori': 'Angkringan',
      },
    ];
  }

  bool isBuka(String status) {
    return status.toLowerCase().contains("buka");
  }

  @override
  Widget build(BuildContext context) {
    final pedagangList = getAllPedagang();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading:
              false, // Sudah benar untuk menghilangkan tombol default
          // leading: Padding(...): Bagian ini yang perlu dihapus untuk menghilangkan tombol back
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Text(
              'Kotak masuk',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A32F4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Chat',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifikasiPage(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: pedagangList.length,
              itemBuilder: (context, index) {
                final pedagang = pedagangList[index];
                final buka = isBuka(pedagang['status']!);

                return ListTile(
                  onTap: () {
                    if (buka) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ChatDetailPage(sellerName: pedagang['name']!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pedagang sedang tutup")),
                      );
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pedagang['image']!),
                  ),
                  title: Text(
                    pedagang['name']!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${pedagang['status']!}\n${pedagang['kategori']}',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                  ),
                  trailing: Icon(
                    Icons.circle,
                    color: buka ? Colors.green : Colors.grey,
                    size: 10,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
