import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CrimesService {
  final Firestore firestore = Firestore.instance;
  final String crimesCollection = "crimes";
  Stream<QuerySnapshot> getCrimes() {
    return firestore.collection(crimesCollection).snapshots();
  }

  Future<DocumentSnapshot> findCrime(LatLng position) async {
    var snap = await firestore
        .collection(crimesCollection)
        .where(
          "location",
          isEqualTo: GeoPoint(
            position.latitude,
            position.longitude,
          ),
        )
        .getDocuments();

    return snap.documents.length > 0 ? snap.documents.first : null;
  }

  addCrime(LatLng position) async {
    DocumentSnapshot crime = await this.findCrime(position);
    if (crime != null) {
      await firestore
          .collection(crimesCollection)
          .document(crime.documentID)
          .setData({
        "report_number": crime.data['report_number'] + 1,
        "location": GeoPoint(position.latitude, position.longitude)
      });
    } else {
      firestore.collection(crimesCollection).add({
        "report_number": 1,
        "location": GeoPoint(position.latitude, position.longitude)
      });
    }
  }
}

final CrimesService crimesService = CrimesService();
