import 'package:flutter/material.dart';

class EncryptPage extends StatefulWidget {
  const EncryptPage({super.key});

  @override
  State<EncryptPage> createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  final TextEditingController _inputCtrl = TextEditingController();
  final TextEditingController _keyCtrl = TextEditingController();
  String _result = '';
  String _mode = 'Encrypt';
  String _algo = 'Atbash'; // Atbash, Vigenere, Caesar

  @override
  void dispose() {
    _inputCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  String atbash(String s) {
    final a = 'abcdefghijklmnopqrstuvwxyz';
    final ra = a.split('').reversed.join();
    return s.split('').map((ch) {
      final lower = ch.toLowerCase();
      final idx = a.indexOf(lower);
      if (idx < 0) return ch;
      final mapped = ra[idx];
      return (ch == lower) ? mapped : mapped.toUpperCase();
    }).join();
  }

  String vigenere(String text, String key, bool encrypt) {
    if (key.isEmpty) return text;
    final a = 'abcdefghijklmnopqrstuvwxyz';
    final keyClean = key.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (keyClean.isEmpty) return text;
    var ki = 0;
    return text.split('').map((ch) {
      final lower = ch.toLowerCase();
      final idx = a.indexOf(lower);
      if (idx < 0) return ch;
      final shift = a.indexOf(keyClean[ki % keyClean.length]);
      final resIdx = encrypt ? (idx + shift) % 26 : (idx - shift + 26) % 26;
      final out = a[resIdx];
      ki++;
      return (ch == lower) ? out : out.toUpperCase();
    }).join();
  }

  String caesar(String text, int shift, bool encrypt) {
    final a = 'abcdefghijklmnopqrstuvwxyz';
    return text.split('').map((ch) {
      final lower = ch.toLowerCase();
      final idx = a.indexOf(lower);
      if (idx < 0) return ch;
      final resIdx = encrypt ? (idx + shift) % 26 : (idx - shift + 26) % 26;
      final out = a[resIdx];
      return (ch == lower) ? out : out.toUpperCase();
    }).join();
  }

  void run() {
    final txt = _inputCtrl.text;
    final key = _keyCtrl.text;
    final encrypt = _mode == 'Encrypt';
    String out = txt;
    if (_algo == 'Atbash') {
      out = atbash(txt);
    } else if (_algo == 'Vigenere') {
      out = vigenere(txt, key, encrypt);
    } else if (_algo == 'Caesar') {
      final shift = int.tryParse(key) ?? 3;
      out = caesar(txt, shift % 26, encrypt);
    }
    setState(() => _result = out);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Encrypt / Decrypt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _inputCtrl, decoration: const InputDecoration(labelText: 'Input text')),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _algo,
                    items: const [
                      DropdownMenuItem(value: 'Atbash', child: Text('Atbash')),
                      DropdownMenuItem(value: 'Vigenere', child: Text('Vigenère')),
                      DropdownMenuItem(value: 'Caesar', child: Text('Cipher text (Caesar)')),
                    ],
                    onChanged: (v) => setState(() => _algo = v ?? 'Atbash'),
                    decoration: const InputDecoration(labelText: 'Algorithm'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _mode,
                    items: const [
                      DropdownMenuItem(value: 'Encrypt', child: Text('Encrypt')),
                      DropdownMenuItem(value: 'Decrypt', child: Text('Decrypt')),
                    ],
                    onChanged: (v) => setState(() => _mode = v ?? 'Encrypt'),
                    decoration: const InputDecoration(labelText: 'Mode'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _keyCtrl,
              decoration: const InputDecoration(
                labelText: 'Key (Vigenère) or shift (Caesar). Leave empty for Atbash.',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: run, child: const Text('Run')),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    _inputCtrl.clear();
                    _keyCtrl.clear();
                    setState(() => _result = '');
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(alignment: Alignment.centerLeft, child: Text('Result', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: Text(_result.isEmpty ? '(empty)' : _result),
            ),
          ],
        ),
      ),
    );
  }
}