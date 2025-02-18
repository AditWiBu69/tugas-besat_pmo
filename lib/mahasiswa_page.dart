import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'add_mahasiswa_page.dart';
import 'edit_mahasiswa_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final Dio _dio = Dio();
  List<dynamic> _mahasiswaList = [];

  @override
  void initState() {
    super.initState();
    _fetchMahasiswaData();
  }

  Future<void> _fetchMahasiswaData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        Response response = await _dio.get(
          'https://bemhs.buxxed.me/api/mahasiswa',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200 && response.data['data'] != null) {
          setState(() {
            _mahasiswaList = response.data['data'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data tidak dapat difetch')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak diitemukan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa List'),
      ),
      body: ListView.builder(
        itemCount: _mahasiswaList.length,
        itemBuilder: (context, index) {
          var mahasiswa = _mahasiswaList[index];
          return ListTile(
            title: Text(mahasiswa['namalengkap']),
            subtitle: Text(mahasiswa['prodi']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMahasiswaPage(
                          mahasiswaId: mahasiswa['userid'],
                          namalengkap: mahasiswa['namalengkap'],
                          prodi: mahasiswa['prodi'],
                          alamat: mahasiswa['alamat'],
                          asalsekolah: mahasiswa['asalsekolah'],
                          onDataUpdated: _fetchMahasiswaData,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteMahasiswa(mahasiswa['userid']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddMahasiswaPage(onDataAdded: _fetchMahasiswaData),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Mahasiswa',
      ),
    );
  }

  Future<void> _deleteMahasiswa(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        Response response = await _dio.delete(
          'https://bemhs.buxxed.me/api/mahasiswa/$userId',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mahasiswa berhasil dihapus')),
          );
          _fetchMahasiswaData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
