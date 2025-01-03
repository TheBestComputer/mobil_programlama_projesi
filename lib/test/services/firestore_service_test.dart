import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:denemeeeeeee/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  late FirestoreService firestoreService;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
  });

  group('Tedarik Operations', () {
    test('createTedarik creates a new supply with correct data', () async {
      final docRef = await firestoreService.createTedarik(
        userId: 'testUserId',
        description: 'Test Tedarik',
        sector: 'Test Sektör',
      );

      final doc = await fakeFirestore.collection('tedarikler').doc(docRef.id).get();
      final data = doc.data();
      
      expect(doc.exists, true);
      expect(data?['description'], 'Test Tedarik');
      expect(data?['sector'], 'Test Sektör');
      expect(data?['userId'], 'testUserId');
      expect(data?['status'], 'active');
    });


  });

  group('User Operations', () {
    test('createUser creates new user document with correct data', () async {
      const userId = 'testUserId';
      const email = 'test@example.com';
      const username = 'testUser';

      await firestoreService.createUser(userId, email, username);

      final userDoc = await fakeFirestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      
      expect(userDoc.exists, true);
      expect(userData?['email'], email);
      expect(userData?['username'], username);
    });
  });

  group('Application Operations', () {
    test('createApplication creates new application with correct data', () async {
      const tedarikId = 'tedarikId';
      const userId = 'applicantId';
      const message = 'Test application message';

      await firestoreService.createApplication(tedarikId, userId, message);

      final querySnapshot = await fakeFirestore
          .collection('tedarikler')
          .doc(tedarikId)
          .collection('applications')
          .get();

      expect(querySnapshot.docs.length, 1);
      final application = querySnapshot.docs.first.data();
      expect(application['userId'], userId);
      expect(application['message'], message);
      expect(application['status'], 'pending');
    });
  });
}
