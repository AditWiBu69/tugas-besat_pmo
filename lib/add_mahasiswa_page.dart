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
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                  _namalengkapController, 'Nama Lengkap', 'Masukan Nama'),
              const SizedBox(height: 16),
              _buildTextField(_prodiController, 'Prodi', 'Masukan Prodi'),
              const SizedBox(height: 16),
              _buildTextField(_alamatController, 'Alamat', 'Masukan Alamat'),
              const SizedBox(height: 16),
              _buildTextField(_asalsekolahController, 'Asal Sekolah',
                  'Masukan nama Sekolah'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Tambah Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.teal.shade700,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto', // Applying custom font here
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}
