import 'package:flutter/material.dart';

class FormMatkulPage extends StatefulWidget {
  const FormMatkulPage({super.key});

  @override
  State<FormMatkulPage> createState() => _FormMatkulPageState();
}

class _FormMatkulPageState extends State<FormMatkulPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // --- Controller
  final cKode = TextEditingController();
  final cNama = TextEditingController();
  String? sks; // pakai dropdown (1,2,3,4,5,6)

  @override
  void dispose() {
    cKode.dispose();
    cNama.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate() || sks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali isian Anda.')),
      );
      return;
    }

    final data = {
      'Kode Matkul': cKode.text.trim(),
      'Nama Matkul': cNama.text.trim(),
      'SKS': sks!,
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ringkasan Data Mata Kuliah'),
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
        title: const Text('Data Mata Kuliah'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Identitas Matkul'),
            TextFormField(
              controller: cKode,
              decoration: const InputDecoration(
                labelText: 'Kode Matkul',
                hintText: 'cth: PPB001',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.code),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Kode Matkul wajib diisi'
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cNama,
              decoration: const InputDecoration(
                labelText: 'Nama Matkul',
                hintText: 'cth: Pemrograman Perangkat Bergerak',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Nama Matkul wajib diisi'
                  : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: sks,
              decoration: const InputDecoration(
                labelText: 'SKS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
              items: ['1', '2', '3', '4', '5', '6']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => sks = val),
              validator: (v) =>
                  v == null ? 'Pilih jumlah SKS' : null,
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Form Mata Kuliah')),
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
