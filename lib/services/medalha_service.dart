import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medalha_model.dart';

class MedalhaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarMedalha(Medalha medalha) async {
    await _db.collection('medalhas').doc(medalha.id).set(medalha.toMap());
  }

  Future<List<Medalha>> obterMedalhas() async {
    final snapshot = await _db.collection('medalhas').get();
    return snapshot.docs
        .map((doc) => Medalha.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletarMedalha(String id) async {
    await _db.collection('medalhas').doc(id).delete();
  }
}
