import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Aplikasi ini dirancang untuk mempermudah proses pendaftaran mahasiswa baru secara online. Dengan antarmuka yang intuitif dan fitur yang lengkap, pengguna dapat dengan mudah mendaftar, mengelola data mahasiswa, serta mengakses informasi terkait penerimaan mahasiswa baru. Aplikasi ini dibangun menggunakan teknologi Flutter untuk tampilan yang responsif dan modern, serta Firebase sebagai basis data untuk memastikan keamanan dan kecepatan akses informasi. Kami berharap aplikasi ini dapat memberikan pengalaman yang lebih efisien dan nyaman bagi calon mahasiswa serta pihak administrasi kampus.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataDiriPage()),
                );
              },
              child: const Text('Lihat Data Diri'),
            ),
          ],
        ),
      ),
    );
  }
}

class DataDiriPage extends StatelessWidget {
  const DataDiriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> biodata = [
      {
        'Nama': 'Aditya Firmansyah',
        'NIM': '714220038',
        'Foto': 'assets/pp.jpg',
      },
      {
        'Nama': 'Mariana Siregar',
        'NIM': '714220068',
        'Foto': 'assets/1.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Data Diri')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: biodata.length,
        itemBuilder: (context, index) {
          final data = biodata[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    data['Foto']!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...data.entries.where((entry) => entry.key != 'Foto').map((entry) {
                          return Text(
                            '${entry.key}: ${entry.value}',
                            style: const TextStyle(fontSize: 16.0),
                          );
                        }).toList(),
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