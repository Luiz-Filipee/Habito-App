import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/registroHabito_model.dart';

class RegistroHabitoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarRegistro(RegistroHabito registro, String habitoId) async {
    final ref = _db
        .collection('habitos')
        .doc(habitoId)
        .collection('registros')
        .doc(registro.id);
    await ref.set(registro.toMap());
  }

  Future<List<RegistroHabito>> obterRegistros(String habitoId) async {
    final querySnapshot = await _db
        .collection('habitos')
        .doc(habitoId)
        .collection('registros')
        .get();
    return querySnapshot.docs
        .map((doc) => RegistroHabito.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> removerRegistro(String habitoId, String registroId) async {
    await _db
        .collection('habitos')
        .doc(habitoId)
        .collection('registros')
        .doc(registroId)
        .delete();
  }
}
