
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class TedarikDetailScreen extends StatefulWidget {
  final String tedarikId;

  const TedarikDetailScreen({super.key, required this.tedarikId});

  @override
  State<TedarikDetailScreen> createState() => _TedarikDetailScreenState();
}

class _TedarikDetailScreenState extends State<TedarikDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _fileUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTedarikDetails();
  }

  Future<void> _loadTedarikDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('tedarikler')
        .doc(widget.tedarikId)
        .get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        _descriptionController.text = data['description'] ?? '';
        _sectorController.text = data['sector'] ?? '';
        _fileUrlController.text = data['fileUrl'] ?? '';
      });
    }
  }

  Stream<QuerySnapshot> _getApplications() {
    return _firestoreService.getTedarikApplications(widget.tedarikId);
  }

  Future<List<Map<String, dynamic>>> _fetchApplicantsWithProfiles() async {
    return await _firestoreService.getApplicantsWithProfiles(widget.tedarikId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedarik Detayı'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tedarik Detaylarını Güncelle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sectorController,
              decoration: const InputDecoration(labelText: 'Sektör'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fileUrlController,
              decoration: const InputDecoration(labelText: 'Dosya URL'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _firestoreService.updateTedarik(
                    widget.tedarikId,
                    description: _descriptionController.text.trim(),
                    sector: _sectorController.text.trim(),
                    fileUrl: _fileUrlController.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tedarik başarıyla güncellendi!')),
                  );
                },
                child: const Text('Güncelle'),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Başvuranlar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchApplicantsWithProfiles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Hiç başvuru bulunamadı.'));
                }

                final applicants = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final applicant = applicants[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(applicant['username'] ?? 'Kullanıcı Adı Yok'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(applicant['email'] ?? 'Email Yok'),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
