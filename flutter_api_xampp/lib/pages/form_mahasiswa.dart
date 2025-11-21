import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();

  final cNama = TextEditingController();
  final cNpm = TextEditingController();
  final cEmail = TextEditingController();
  final cAlamat = TextEditingController();

  DateTime? tglLahir;
  TimeOfDay? jamBimbingan;

  String get tglLahirLabel => tglLahir == null
      ? 'Pilih tanggal lahir'
      : '${tglLahir!.day}/${tglLahir!.month}/${tglLahir!.year}';

  String get jamLabel =>
      jamBimbingan == null ? 'Pilih jam bimbingan' : jamBimbingan!.format(context);

  @override
  void dispose() {
    cNama.dispose();
    cNpm.dispose();
    cEmail.dispose();
    cAlamat.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: DateTime.now(),
    );

    if (result != null) setState(() => tglLahir = result);
  }

    Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (result != null) {
      setState(() => jamBimbingan = result);
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // format MySQL
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali isian Anda')),
      );
      return;
    }

    if (tglLahir == null || jamBimbingan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir & jam bimbingan wajib diisi')),
      );
      return;
    }

    final url = Uri.parse("http://192.168.18.7/flutter_api_Xampp/add_users.php");

    final response = await http.post(url, body: {
      "nama": cNama.text.trim(),
      "npm": cNpm.text.trim(),
      "email": cEmail.text.trim(),
      "alamat": cAlamat.text.trim(),
      "tgl_lahir": "${tglLahir!.year}-${tglLahir!.month}-${tglLahir!.day}",
      "jam_bimbingan": formatTimeOfDay(jamBimbingan!),  // ← ini yang diperbaiki
    });

    if (response.statusCode == 200) {
      Navigator.pop(context, "refresh");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Mahasiswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: cNama,
                decoration: _inputStyle("Nama Lengkap", Icons.person),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cNpm,
                decoration: _inputStyle("NPM", Icons.numbers),
                validator: (v) => v!.isEmpty ? "NPM wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cEmail,
                decoration: _inputStyle("Email", Icons.email),
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cAlamat,
                decoration: _inputStyle("Alamat", Icons.home),
                validator: (v) => v!.isEmpty ? "Alamat wajib diisi" : null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cake),
                      label: Text(tglLahirLabel),
                      onPressed: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.schedule),
                      label: Text(jamLabel),
                      onPressed: _pickTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Simpan", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _simpan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
