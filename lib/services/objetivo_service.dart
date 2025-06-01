import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/objetivo_model.dart';

class ObjetivoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarObjetivo(Objetivo objetivo) async {
    await _db.collection('objetivos').doc(objetivo.id).set(objetivo.toMap());
  }

  Future<List<Objetivo>> obterObjetivos() async {
    final snapshot = await _db.collection('objetivos').get();
    return snapshot.docs
        .map((doc) => Objetivo.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletarObjetivo(String id) async {
    await _db.collection('objetivos').doc(id).delete();
  }
}
