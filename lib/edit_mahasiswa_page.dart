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
      appBar: AppBar(
        title: const Text('Edit Data Mahasiswa'),
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
                    return 'Masukan nama';
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
                    return 'Masukan prodi';
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
                    return 'Masukan alamat';
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
                    return 'Masukan nama sekolah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Edit Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
