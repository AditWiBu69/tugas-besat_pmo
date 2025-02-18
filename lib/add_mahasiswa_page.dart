import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMahasiswaPage extends StatefulWidget {
  final Function onDataAdded;

  const AddMahasiswaPage({super.key, required this.onDataAdded});

  @override
  _AddMahasiswaPageState createState() => _AddMahasiswaPageState();
}

class _AddMahasiswaPageState extends State<AddMahasiswaPage> {
  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _asalsekolahController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token != null) {
          Response response = await _dio.post(
            'https://bemhs.buxxed.me/api/mahasiswa',
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
              const SnackBar(content: Text('Mahasiswa ditambahkan!')),
            );
            widget.onDataAdded();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal menambah data')),
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
      appBar: AppBar(
        title: const Text('Tambah Data Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _namalengkapController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan Nama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prodiController,
                decoration: const InputDecoration(labelText: 'Prodi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan Prodi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan Alamat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _asalsekolahController,
                decoration: const InputDecoration(labelText: 'Asal Sekolah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan nama Sekolah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Tambah Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
