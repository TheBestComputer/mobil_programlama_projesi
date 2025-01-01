
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class TedarikViewScreen extends StatelessWidget {
  final String tedarikId;
  final FirestoreService _firestoreService = FirestoreService();

  TedarikViewScreen({super.key, required this.tedarikId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedarik Detayı'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tedarikler')
            .doc(tedarikId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Tedarik bulunamadı.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tedarik Details Card
                Card(
                  color : Colors.grey.shade300,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tedarik Bilgileri',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        _buildDetailRow('Açıklama', data['description'] ?? '-'),
                        const SizedBox(height: 8),
                        _buildDetailRow('Sektör', data['sector'] ?? '-'),
                        if (data['fileUrl'] != null) ...[
                          const SizedBox(height: 8),
                          _buildDetailRow('Dosya', data['fileUrl']),
                        ]
                      ],
                    ),
                  ),
                ),

                // Applicants Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Başvuranlar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _firestoreService.getApplicantsWithProfiles(tedarikId),
                  builder: (context, applicantsSnapshot) {
                    if (applicantsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!applicantsSnapshot.hasData ||
                        applicantsSnapshot.data!.isEmpty) {
                      return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Henüz başvuru yapılmamış.'),
                          ));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: applicantsSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        final applicant = applicantsSnapshot.data![index];
                        return Card(
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(applicant['username'] ?? 'İsimsiz Kullanıcı'),
                            subtitle: Text(applicant['email'] ?? ''),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}


