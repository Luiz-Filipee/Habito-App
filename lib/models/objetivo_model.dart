class Objetivo {
  final String id;
  final String nome;
  final String descricao;
  final String categoria;

  Objetivo({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria
  });

  factory Objetivo.fromMap(Map<String, dynamic> map, String id) {
    return Objetivo(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      categoria: map['categoria'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria
    };
  }
}
