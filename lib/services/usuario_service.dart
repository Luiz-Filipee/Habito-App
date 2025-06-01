import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Usuario> obterUsuario(String userId) async {
    DocumentSnapshot doc = await _db.collection('usuarios').doc(userId).get();
    return Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> criarUsuario(Usuario usuario) async {
    await _db.collection('usuarios').doc(usuario.id).set(usuario.toMap());
  }

  Future<void> removerUsuario(String userId) async {
    await _db.collection('usuarios').doc(userId).delete();
  }
}