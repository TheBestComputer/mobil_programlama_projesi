
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/firestore_service.dart';

class ShareTedarikScreen extends StatefulWidget {
  final String userId;

  const ShareTedarikScreen({super.key, required this.userId});

  @override
  State<ShareTedarikScreen> createState() => _ShareTedarikScreenState();
}

class _ShareTedarikScreenState extends State<ShareTedarikScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _sectorController = TextEditingController();
  final _firestoreService = FirestoreService();

  File? _selectedFile;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _shareTedarik() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? fileUrl;
      if (_selectedFile != null) {
        // Önce boş bir döküman oluşturup ID alalım
        final docRef = await _firestoreService.createTedarik(
          userId: widget.userId,
          description: _descriptionController.text,
          sector: _sectorController.text,
        );

        // Dosyayı yükleyelim
        fileUrl = await _firestoreService.uploadTedarikFile(_selectedFile!, docRef.id);

        // Tedariki dosya URL'si ile güncelleyelim
        await _firestoreService.updateTedarik(docRef.id, fileUrl: fileUrl);
      } else {
        await _firestoreService.createTedarik(
          userId: widget.userId,
          description: _descriptionController.text,
          sector: _sectorController.text,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tedarik başarıyla paylaşıldı')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Tedarik paylaşılırken bir hata oluştu: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedarik Paylaş'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                hintText: 'Tedarik bilgilerini girin',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir açıklama girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sectorController,
              decoration: const InputDecoration(
                labelText: 'Sektör',
                hintText: 'İlgili sektörü belirtin',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir sektör girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _pickFile,
              icon: const Icon(Icons.attach_file),
              label: Text(_selectedFile != null
                ? 'Seçilen Dosya: ${_selectedFile!.path.split('/').last}'
                : 'Dosya Ekle'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _shareTedarik,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Paylaş'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _sectorController.dispose();
    super.dispose();
  }
}

