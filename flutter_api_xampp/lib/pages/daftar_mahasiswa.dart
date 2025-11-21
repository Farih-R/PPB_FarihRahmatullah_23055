import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'form_mahasiswa.dart';

class DaftarMahasiswaPage extends StatefulWidget {
  const DaftarMahasiswaPage({super.key});

  @override
  State<DaftarMahasiswaPage> createState() => _DaftarMahasiswaPageState();
}

class _DaftarMahasiswaPageState extends State<DaftarMahasiswaPage> {
  List<Map<String, dynamic>> mahasiswaList = [];
  bool isLoading = true;
  String errorMessage = '';

  final String apiBase = "http://192.168.18.7/flutter_api_Xampp";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // =======================
  // GET DATA DARI API
  // =======================
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = Uri.parse("$apiBase/get_users.php");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          mahasiswaList =
              List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal mengambil data dari server.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  // =======================
  // DELETE DATA API
  // =======================
  Future<void> _deleteMahasiswa(String id, String nama) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus data "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final url = Uri.parse("$apiBase/delete_users.php");
        final response = await http.post(url, body: {'id': id});

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data["status"] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data "$nama" berhasil dihapus')),
            );
            _loadData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal menghapus data')),
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

  // =======================
  // NAVIGASI KE FORM
  // =======================
  Future<void> _navigateToForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormMahasiswaPage(),
      ),
    );

    if (result == "refresh") {
      _loadData();
    }
  }

  // =======================
  // UI SAMA SEPERTI VERSI SQL LITE
  // =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ${mahasiswaList.length} mahasiswa',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _navigateToForm,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Mahasiswa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? _loadingWidget()
                : errorMessage.isNotEmpty
                    ? _errorWidget()
                    : mahasiswaList.isEmpty
                        ? _emptyWidget()
                        : _buildDataTable(),
          ),
        ],
      ),
    );
  }

  // =======================  UI COMPONENTS  =======================

  Widget _loadingWidget() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Memuat data..."),
          ],
        ),
      );

  Widget _errorWidget() => Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );

  Widget _emptyWidget() => const Center(
        child: Text("Belum ada data"),
      );

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('NPM')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Alamat')),
          DataColumn(label: Text('Tanggal Lahir')),
          DataColumn(label: Text('Jam Bimbingan')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: mahasiswaList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> m = entry.value;

          return DataRow(
            cells: [
              DataCell(Text("${index + 1}")),
              DataCell(Text(m["npm"])),
              DataCell(Text(m["nama"])),
              DataCell(Text(m["email"])),
              DataCell(SizedBox(width: 150, child: Text(m["alamat"]))),
              DataCell(Text(m["tgl_lahir"])),
              DataCell(Text(m["jam_bimbingan"])),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _deleteMahasiswa(m["id"].toString(), m["nama"]),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
