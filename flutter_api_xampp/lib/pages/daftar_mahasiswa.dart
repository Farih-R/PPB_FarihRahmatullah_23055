import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'form_mahasiswa.dart';

class DaftarMahasiswa extends StatefulWidget {
  const DaftarMahasiswa({super.key});

  @override
  State<DaftarMahasiswa> createState() => _DaftarMahasiswaState();
}

class _DaftarMahasiswaState extends State<DaftarMahasiswa> {
  List mahasiswa = [];

  Future<void> getMahasiswa() async {
    final url =
        Uri.parse("http://192.168.18.7/flutter_api_Xampp/get_users.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        mahasiswa = json.decode(response.body);
      });
    } else {
      print("Gagal mengambil data");
    }
  }

  Future<void> deleteMahasiswa(String id) async {
  final url = Uri.parse("http://192.168.18.7/flutter_api_Xampp/delete_users.php");

  final response = await http.post(url, body: {"id": id});

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil dihapus")),
      );
      getMahasiswa(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus data")),
      );
    }
  }
}


  @override
  void initState() {
    super.initState();
    getMahasiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f1f6),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("flutter_api"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getMahasiswa,
          )
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER TULISAN "Daftar Mahasiswa"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Daftar Mahasiswa",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // TOTAL + BUTTON TAMBAH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${mahasiswa.length} mahasiswa",
                  style: const TextStyle(fontSize: 16),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Mahasiswa"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FormMahasiswaPage()),
                    );

                    if (result == "refresh") {
                      getMahasiswa();
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TABEL HEADER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: const [
                Expanded(flex: 1, child: Text("No")),
                Expanded(flex: 3, child: Text("NPM")),
                Expanded(flex: 3, child: Text("Nama")),
                Expanded(flex: 4, child: Text("Email")),
                Expanded(flex: 3, child: Text("Alamat")),
                Expanded(flex: 3, child: Text("Tanggal Lahir")),
                Expanded(flex: 3, child: Text("Jam Bimbingan")),
                Expanded(flex: 1, child: Text("Aksi")),
              ],
            ),
          ),

          const Divider(height: 1),

          // LIST DATA
          Expanded(
            child: mahasiswa.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: mahasiswa.length,
                    itemBuilder: (context, index) {
                      final m = mahasiswa[index];

                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Text("${index + 1}")),
                            Expanded(flex: 3, child: Text(m["npm"])),
                            Expanded(flex: 3, child: Text(m["nama"])),
                            Expanded(flex: 4, child: Text(m["email"])),
                            Expanded(flex: 3, child: Text(m["alamat"])),
                            Expanded(flex: 3, child: Text(m["tgl_lahir"])),
                            Expanded(flex: 3, child: Text(m["jam_bimbingan"])),

                            // ICON DELETE
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Hapus Data"),
                                        content: Text("Yakin ingin menghapus ${m["nama"]}?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Batal"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: const Text("Hapus"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              deleteMahasiswa(m["id"].toString());
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  

                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
