class Noticia {
  final int id;
  final String titulo;
  final String resumo;
  final String conteudo;
  final String? imagem;
  final int categoriaId;
  final String categoriaNome;
  final DateTime createdAt;

  Noticia({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.conteudo,
    this.imagem,
    required this.categoriaId,
    required this.categoriaNome,
    required this.createdAt,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      titulo: json['titulo'],
      resumo: json['resumo'],
      conteudo: json['conteudo'],
      imagem: json['imagem'],
      categoriaId: json['categoria_id'],
      categoriaNome: json['categoria_nome'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get dataFormatada {
    final dia = createdAt.day.toString().padLeft(2, '0');
    final mes = createdAt.month.toString().padLeft(2, '0');
    final ano = createdAt.year.toString();
    return '$dia/$mes/$ano';
  }
}
