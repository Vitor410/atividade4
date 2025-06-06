class CollectionItem {
  final int? id;
  final int collectionId;
  final String nome;
  final String descricao;
  final DateTime dataAquisicao;
  final double valor;
  final String condicao;
  final String? fotoPath;
  final String detalhesEspecificos;
  final String categoria; // Novo campo

  CollectionItem({
    this.id,
    required this.collectionId,
    required this.nome,
    required this.descricao,
    required this.dataAquisicao,
    required this.valor,
    required this.condicao,
    this.fotoPath,
    required this.detalhesEspecificos,
    required this.categoria, // Novo campo obrigatório
  });

  Map<String, dynamic> toMap() { 
    return {
      "id": id,
      "collection_id": collectionId,
      "nome": nome,
      "descricao": descricao,
      "data_aquisicao": dataAquisicao.toIso8601String(),
      "valor": valor,
      "condicao": condicao,
      "foto_path": fotoPath,
      "detalhes_especificos": detalhesEspecificos,
      "categoria": categoria, // Novo campo no mapa
    };
  }

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
    return CollectionItem(
      id: map["id"] as int?,
      collectionId: map["collection_id"] as int,
      nome: map["nome"] as String,
      descricao: map["descricao"] as String,
      dataAquisicao: DateTime.parse(map["data_aquisicao"] as String),
      valor: (map["valor"] as num).toDouble(),
      condicao: map["condicao"] as String,
      fotoPath: map["foto_path"] as String?,
      detalhesEspecificos: map["detalhes_especificos"] as String,
      categoria: map["categoria"] as String, // Novo campo no factory
    );
  }

  @override
  String toString() {
    return "CollectionItem{id: $id, collectionId: $collectionId, nome: $nome, descricao: $descricao, dataAquisicao: $dataAquisicao, valor: $valor, condicao: $condicao, fotoPath: $fotoPath, detalhesEspecificos: $detalhesEspecificos, categoria: $categoria}"; // Adicione categoria ao toString
  }
}
