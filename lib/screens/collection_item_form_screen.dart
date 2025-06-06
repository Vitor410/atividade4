import 'package:flutter/material.dart';
import '../models/collection_item_model.dart';

class CollectionItemFormScreen extends StatefulWidget {
  final int collectionId;
  final bool isHQ;
  const CollectionItemFormScreen({Key? key, required this.collectionId, this.isHQ = false}) : super(key: key);

  @override
  State<CollectionItemFormScreen> createState() => _CollectionItemFormScreenState();
}

class _CollectionItemFormScreenState extends State<CollectionItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String descricao = '';
  DateTime? dataAquisicao;
  String valor = '';
  String condicao = '';
  String detalhesEspecificos = '';
  String fotoPath = '';
  final categoriaController = TextEditingController();

  String get detalhesHint {
    // Exemplo dinâmico para detalhes específicos
    if (widget.isHQ) return 'roteirista, editora, edição especial';
    // Você pode expandir para outros tipos se desejar
    return 'ex: país da moeda, ano, edição especial';
  }

  String get categoriaHint {
    if (widget.isHQ) return 'Marvel, DC, Mangá';
    return 'ex: Moeda, Selo, HQ';
  }

  @override
  void dispose() {
    categoriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do item'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                onSaved: (v) => nome = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (v) => descricao = v ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Data de aquisição (AAAA-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a data' : null,
                onSaved: (v) => dataAquisicao = DateTime.tryParse(v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Informe o valor' : null,
                onSaved: (v) => valor = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Condição (ex: Nova, Usada)'),
                onSaved: (v) => condicao = v ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Detalhes específicos',
                  hintText: detalhesHint,
                ),
                onSaved: (v) => detalhesEspecificos = v ?? '',
              ),
              TextFormField(
                controller: categoriaController,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  hintText: categoriaHint,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Informe a categoria' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Foto (caminho do arquivo ou URL)',
                  hintText: 'Opcional',
                ),
                onSaved: (v) => fotoPath = v ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final item = CollectionItem(
                      collectionId: widget.collectionId,
                      nome: nome,
                      descricao: descricao,
                      dataAquisicao: dataAquisicao ?? DateTime.now(),
                      valor: double.tryParse(valor) ?? 0.0,
                      condicao: condicao,
                      fotoPath: fotoPath.isEmpty ? null : fotoPath,
                      detalhesEspecificos: detalhesEspecificos,
                      categoria: categoriaController.text,
                    );
                    Navigator.pop(context, item);
                  }
                },
                child: Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
