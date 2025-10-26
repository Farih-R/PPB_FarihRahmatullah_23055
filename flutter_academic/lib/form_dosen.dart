import 'package:flutter/material.dart';

class FormDosenPage extends StatefulWidget {
  const FormDosenPage({super.key});

  @override
  State<FormDosenPage> createState() => _FormDosenPageState();
}

class _FormDosenPageState extends State<FormDosenPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // --- Controller
  final cNidn = TextEditingController();
  final cNama = TextEditingController();
  final cHomeBase = TextEditingController();
  final cEmail = TextEditingController();
  final cTelp = TextEditingController();

  @override
  void dispose() {
    cNidn.dispose();
    cNama.dispose();
    cHomeBase.dispose();
    cEmail.dispose();
    cTelp.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali isian Anda.')),
      );
      return;
    }

    final data = {
      'NIDN': cNidn.text.trim(),
      'Nama': cNama.text.trim(),
      'Home Base': cHomeBase.text.trim(),
      'Email': cEmail.text.trim(),
      'No Telp': cTelp.text.trim(),
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ringkasan Data Dosen'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('${e.key}: ${e.value}'),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final steps = <Step>[
      Step(
        title: const Text('Data Dosen'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Identitas Dosen'),
            TextFormField(
              controller: cNidn,
              decoration: const InputDecoration(
                labelText: 'NIDN',
                hintText: 'cth: 35362*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'NIDN wajib diisi' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cNama,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'cth: Azhari Ali Ridha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cHomeBase,
              decoration: const InputDecoration(
                labelText: 'Home Base',
                hintText: 'cth: Universitas Singaperbangsa Karawang',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home_work),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Home Base wajib diisi'
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'cth: Aulia@gmail.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Email wajib diisi' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cTelp,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No Telp',
                hintText: 'cth: 0857722*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'No Telp wajib diisi'
                  : null,
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Form Dosen')),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          steps: steps,
          onStepContinue: _simpan,
          onStepCancel: null,
          controlsBuilder: (context, details) {
            return Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Simpan'),
                  onPressed: details.onStepContinue,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
