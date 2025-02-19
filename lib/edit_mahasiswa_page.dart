import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMahasiswaPage extends StatefulWidget {
  final String mahasiswaId;
  final String namalengkap;
  final String prodi;
  final String alamat;
  final String asalsekolah;
  final Function onDataUpdated;

  const EditMahasiswaPage({
    super.key,
    required this.mahasiswaId,
    required this.namalengkap,
    required this.prodi,
    required this.alamat,
    required this.asalsekolah,
    required this.onDataUpdated,
  });

  @override
  _EditMahasiswaPageState createState() => _EditMahasiswaPageState();
}

class _EditMahasiswaPageState extends State<EditMahasiswaPage> {
  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _asalsekolahController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _namalengkapController.text = widget.namalengkap;
    _prodiController.text = widget.prodi;
    _alamatController.text = widget.alamat;
    _asalsekolahController.text = widget.asalsekolah;
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token != null) {
          Response response = await _dio.put(
            'https://bemhs.buxxed.me/api/mahasiswa/${widget.mahasiswaId}',
            data: {
              'namalengkap': _namalengkapController.text,
              'prodi': _prodiController.text,
              'alamat': _alamatController.text,
              'asalsekolah': _asalsekolahController.text,
            },
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil diedit!')),
            );
            widget.onDataUpdated();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal mengubah data mahasiswa')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit Data Mahasiswa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'CustomFont', // Replace with your font name
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _namalengkapController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.teal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan nama';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prodiController,
                    decoration: const InputDecoration(
                      labelText: 'Prodi',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.teal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan prodi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.teal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan alamat';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _asalsekolahController,
                    decoration: const InputDecoration(
                      labelText: 'Asal Sekolah',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.teal,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan nama sekolah';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Edit Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700, // Background color
                      foregroundColor:
                          Colors.white, // Updated text color property
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
