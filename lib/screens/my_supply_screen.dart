

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'tedarik_detail_screen.dart';

class MyTedariklerScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  MyTedariklerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paylaştıklarım'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _firestoreService.getUserTedarikler(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Henüz tedarik paylaşmadınız.'));
          }

          final tedarikler = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: tedarikler.length,
            itemBuilder: (context, index) {
              final data = tedarikler[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    data['description'] ?? 'Açıklama yok',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sektör: ${data['sector']}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        'Durum: ${data['status']}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TedarikDetailScreen(tedarikId: tedarikler[index].id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

