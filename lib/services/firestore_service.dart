

//firestore service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirestoreService({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  // User Operations
  Future<void> createUser(String userId, String email, String username) async {
    await firestore.collection('users').doc(userId).set({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserProfile(String userId) {
    return firestore.collection('users').doc(userId).get();
  }

  // File Upload Operations
  Future<String> uploadTedarikFile(File file, String tedarikId) async {
    final storageRef = storage.ref().child('tedarik_files/$tedarikId/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = await storageRef.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<String> uploadTedarikImage(File imageFile, String tedarikId) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = storage.ref().child('tedarik_images/$tedarikId/$fileName');

    final uploadTask = await storageRef.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await uploadTask.ref.getDownloadURL();
  }

  // Tedarik Operations
  Future<DocumentReference> createTedarik({
    required String userId,
    required String description,
    required String sector,
    String? fileUrl,
    String? imageUrl,
  }) {
    return firestore.collection('tedarikler').add({
      'userId': userId,
      'description': description,
      'sector': sector,
      'fileUrl': fileUrl ?? '',
      'imageUrl': imageUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  Future<void> updateTedarik(String tedarikId, {
    String? description,
    String? sector,
    String? fileUrl,
    String? imageUrl,
    String? status,
  }) {
    final Map<String, dynamic> updates = {};
    if (description != null) updates['description'] = description;
    if (sector != null) updates['sector'] = sector;
    if (fileUrl != null) updates['fileUrl'] = fileUrl;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;
    if (status != null) updates['status'] = status;
    updates['updatedAt'] = FieldValue.serverTimestamp();

    return firestore.collection('tedarikler').doc(tedarikId).update(updates);
  }

  Stream<QuerySnapshot> getAllTedarikler() {
    return firestore
        .collection('tedarikler')
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  Stream<QuerySnapshot> getUserTedarikler(String userId) {
    return firestore
        .collection('tedarikler')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> searchTedarikler(String query) {
    return firestore
        .collection('tedarikler')
        .where('status', isEqualTo: 'active')
        .orderBy('description')
        .startAt([query.toLowerCase()])
        .endAt([query.toLowerCase() + '\uf8ff'])
        .snapshots();
  }

  // Application Operations
  Future<void> createApplication(String tedarikId, String userId, String message) {
    return firestore
        .collection('tedarikler')
        .doc(tedarikId)
        .collection('applications')
        .add({
      'userId': userId,
      'message': message,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTedarikApplications(String tedarikId) {
    return firestore
        .collection('tedarikler')
        .doc(tedarikId)
        .collection('applications')
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getApplicantsWithProfiles(String tedarikId) async {
    final applications = await firestore
        .collection('tedarikler')
        .doc(tedarikId)
        .collection('applications')
        .get();

    List<Map<String, dynamic>> applicantProfiles = [];

    for (var application in applications.docs) {
      final userId = application['userId'];
      final userProfile = await getUserProfile(userId);

      if (userProfile.exists) {
        applicantProfiles.add({
          'username': userProfile['username'],
          'email': userProfile['email'],
        });
      }
    }

    return applicantProfiles;
  }
}