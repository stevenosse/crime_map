import 'package:cloud_firestore/cloud_firestore.dart';

class CrimesService {
  final Firestore firestore = Firestore.instance;
  Stream<QuerySnapshot> getCrimes() {
    return firestore.collection("crimes").snapshots();
  }
}

final CrimesService crimesService = CrimesService();
