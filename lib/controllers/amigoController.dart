import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AmigoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? meuUid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> enviarPedidoAmizade(String emailAmigo) async {
    print('teste $meuUid');
    if (meuUid == null) return;
    final snapshot = await _firestore
        .collection('usuarios')
        .where('email', isEqualTo: emailAmigo)
        .get();
    print('dado $snapshot');
    if (snapshot.docs.isEmpty) return;
    final uidAmigo = snapshot.docs.first.id;
    print('idamigo $uidAmigo');
    await _firestore.collection('usuarios').doc(uidAmigo).update({
      'pedidosAmizade': FieldValue.arrayUnion([meuUid])
    });
  }

  Future<void> aceitarAmizade(String uidAmigo) async {
    if (meuUid == null) return;
    await _firestore.collection('usuarios').doc(meuUid).update({
      'amigos': FieldValue.arrayUnion([uidAmigo]),
      'pedidosAmizade': FieldValue.arrayRemove([uidAmigo]),
    });

    await _firestore.collection('usuarios').doc(uidAmigo).update({
      'amigos': FieldValue.arrayUnion([meuUid]),
    });
  }

  Future<void> recusarAmizade(String uidAmigo) async {
    if (meuUid == null) return;
    await _firestore.collection('usuarios').doc(meuUid).update({
      'pedidosAmizade': FieldValue.arrayRemove([uidAmigo]),
    });
  }

  Future<void> removerAmigo(String uidAmigo) async {
    if (meuUid == null) return;

    await _firestore.collection('usuarios').doc(meuUid).update({
      'amigos': FieldValue.arrayRemove([uidAmigo]),
    });

    await _firestore.collection('usuarios').doc(uidAmigo).update({
      'amigos': FieldValue.arrayRemove([meuUid]),
    });
  }

  Stream<QuerySnapshot> listarAmigos() {
    if (meuUid == null) return const Stream.empty();

    return _firestore
        .collection('usuarios')
        .doc(meuUid)
        .snapshots()
        .asyncExpand(
      (doc) {
        final amigos = List<String>.from(doc.get('amigos') ?? []);
        if (amigos.isEmpty) return const Stream.empty();
        return _firestore
            .collection('usuarios')
            .where(FieldPath.documentId, whereIn: amigos)
            .snapshots();
      },
    );
  }

  Stream<QuerySnapshot> listarPedidos() {
    if (meuUid == null) return const Stream.empty();
    return _firestore
        .collection('usuarios')
        .doc(meuUid)
        .snapshots()
        .asyncExpand(
      (doc) {
        final pedidos = List<String>.from(doc.get('pedidosAmizade') ?? []);
        if (pedidos.isEmpty) return const Stream.empty();
        return _firestore
            .collection('usuarios')
            .where(FieldPath.documentId, whereIn: pedidos)
            .snapshots();
      },
    );
  }
}
