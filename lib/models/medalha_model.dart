class Medalha {
  final String id;
  final String nome;
  final String descricao;
  final String imagem;
  final String requisitos;


  Medalha({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.requisitos
  });

  factory Medalha.fromMap(Map<String, dynamic> map, String id) {
    return Medalha(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      imagem: map['imagem'] ?? '',
      requisitos: map['requisitos'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'imagem': imagem,
      'requisitos': requisitos
    };
  }
}
