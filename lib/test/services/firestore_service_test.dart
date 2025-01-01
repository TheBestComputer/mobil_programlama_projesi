
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:denemeeeeeee/services/firestore_service.dart';

void main() {
  late FirestoreService firestoreService;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
  });

  test('Tedarik oluşturma işlemi başarılı', () async {
    final docRef = await firestoreService.createTedarik(
      userId: 'testUserId',
      description: 'Test Tedarik',
      sector: 'Test Sektör',
    );

    final doc = await fakeFirestore.collection('tedarikler').doc(docRef.id).get();

    expect(doc.exists, true);
    expect(doc.data()?['description'], 'Test Tedarik');
    expect(doc.data()?['sector'], 'Test Sektör');
  });
}