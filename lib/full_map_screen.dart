import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Import ini untuk FlutterMap
import 'package:latlong2/latlong.dart'; // Import ini untuk LatLng

class FullMapScreen extends StatefulWidget {
  // Karena kita ingin selalu di Surabaya untuk contoh ini,
  // kita tidak perlu lagi menerima center dari constructor,
  // atau Anda bisa tetap menerimanya dan mengabaikannya jika mau selalu di Surabaya.
  // final LatLng center;
  // const FullMapScreen({super.key, required this.center});

  const FullMapScreen({super.key}); // Ubah constructor jika center tidak lagi diterima

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  // Koordinat Surabaya (sekitar pusat kota)
  final LatLng _surabayaCenter = LatLng(-7.2575, 112.7521); // Koordinat lat, long Surabaya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peta KakiLima (Surabaya)', // Judul bisa disesuaikan
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7B2CBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FlutterMap( // Widget FlutterMap untuk menampilkan peta
        options: MapOptions(
          initialCenter: _surabayaCenter, // Pusat peta di Surabaya
          initialZoom: 12.0, // Level zoom awal
          minZoom: 3.0, // Zoom paling jauh
          maxZoom: 18.0, // Zoom paling dekat
          // Jika Anda ingin bisa menggeser ke luar batas tertentu:
          // maxBounds: LatLngBounds(
          //   LatLng(-7.5, 112.5), // Batas Barat Daya
          //   LatLng(-7.0, 113.0), // Batas Timur Laut
          // ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'kakilima_app', // Pastikan ini sesuai dengan package name Anda
          ),
          // Ini adalah MarkerLayer untuk menampilkan penanda di peta
          MarkerLayer(
            markers: [
              Marker(
                point: _surabayaCenter, // Marker berada di pusat Surabaya
                width: 80.0,
                height: 80.0,
                child: const Icon(
                  Icons.location_on, // Ikon penanda lokasi
                  color: Colors.red, // Warna ikon
                  size: 40.0, // Ukuran ikon
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}