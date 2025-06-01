import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notificacao_model.dart';

class NotificacaoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarNotificacao(Notificacao notificacao) async {
    await _db
        .collection('notificacoes')
        .doc(notificacao.id)
        .set(notificacao.toMap());
  }

  Future<List<Notificacao>> obterNotificacoes() async {
    final snapshot = await _db.collection('notificacoes').get();
    return snapshot.docs
        .map((doc) => Notificacao.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletarNotificacao(String id) async {
    await _db.collection('notificacoes').doc(id).delete();
  }
}
