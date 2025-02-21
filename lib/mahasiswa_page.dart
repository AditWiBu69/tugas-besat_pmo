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
        title: const Text('Mahasiswa List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _mahasiswaList.length,
        itemBuilder: (context, index) {
          var mahasiswa = _mahasiswaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                mahasiswa['namalengkap'],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mahasiswa['prodi'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    mahasiswa['alamat'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              leading: mahasiswa['foto_profil'] != null &&
                      mahasiswa['foto_profil'].isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(mahasiswa['foto_profil']),
                      backgroundColor: Colors.transparent,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.teal[100],
                      child: Text(
                        mahasiswa['namalengkap'][0],
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white),
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
                            fotoProfil: mahasiswa[
                                'foto_profil'], // Added fotoProfil parameter
                            onDataUpdated: _fetchMahasiswaData,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _deleteMahasiswa(mahasiswa['userid']);
                    },
                  ),
                ],
              ),
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
        backgroundColor: Colors.teal,
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
