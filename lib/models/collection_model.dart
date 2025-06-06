class Collection {
  final int? id;
  final String nome;
  final String descricao;
  final String tipoItem;

  Collection({
    this.id,
    required this.nome,
    required this.descricao,
    required this.tipoItem,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "descricao": descricao,
      "tipo_item": tipoItem,
    }; 
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map["id"] as int?,
      nome: map["nome"] as String,
      descricao: map["descricao"] as String,
      tipoItem: map["tipo_item"] as String,
    );
  }

  @override
  String toString() {
    return "Collection{id: $id, nome: $nome, descricao: $descricao, tipoItem: $tipoItem}";
  }
}
