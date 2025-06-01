class Categoria {
  final String id;
  final String nome;
  final String descricao;

  Categoria({
    required this.id,
    required this.nome,
    required this.descricao
  });

  factory Categoria.fromMap(Map<String, dynamic> map, String id) {
    return Categoria(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao
    };
  }
}
