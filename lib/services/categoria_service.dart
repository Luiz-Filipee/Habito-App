import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarCategoria(Categoria categoria) async {
    await _db.collection('categorias').doc(categoria.id).set(categoria.toMap());
  }

  Future<List<Categoria>> obterCategorias() async {
    final snapshot = await _db.collection('categorias').get();
    return snapshot.docs
        .map((doc) => Categoria.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletarCategoria(String id) async {
    await _db.collection('categorias').doc(id).delete();
  }
}
