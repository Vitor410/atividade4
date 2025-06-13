import 'package:flutter/material.dart';
import '../models/collection_item_model.dart';
// Adicione este import se quiser usar o image_picker
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

class CollectionItemFormScreen extends StatefulWidget {
  final int collectionId;
  final bool isHQ;
  const CollectionItemFormScreen({Key? key, required this.collectionId, this.isHQ = false}) : super(key: key);

  @override
  State<CollectionItemFormScreen> createState() => _CollectionItemFormScreenState();
}

class _CollectionItemFormScreenState extends State<CollectionItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final fotoController = TextEditingController();
  final categoriaController = TextEditingController();

  String nome = '';
  String descricao = '';
  DateTime? dataAquisicao;
  String valor = '';
  String condicao = '';
  String detalhesEspecificos = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final item = ModalRoute.of(context)?.settings.arguments as CollectionItem?;
    if (item != null) {
      nome = item.nome;
      descricao = item.descricao;
      dataAquisicao = item.dataAquisicao;
      valor = item.valor.toString();
      condicao = item.condicao;
      detalhesEspecificos = item.detalhesEspecificos;
      fotoController.text = item.fotoPath ?? '';
      categoriaController.text = item.categoria;
    }
  }

  String get detalhesHint {
    if (widget.isHQ) return 'roteirista, editora, edição especial';
    return 'ex: país da moeda, ano, edição especial';
  }

  String get categoriaHint {
    if (widget.isHQ) return 'Marvel, DC, Mangá';
    return 'ex: Moeda, Selo, HQ';
  }

  @override
  void dispose() {
    categoriaController.dispose();
    fotoController.dispose();
    super.dispose();
  }

  // Se quiser permitir seleção de imagem da galeria, descomente este método e os imports
  /*
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        fotoController.text = picked.path;
      });
    }
  }
  */

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
                initialValue: nome,
                decoration: InputDecoration(labelText: 'Nome do item'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                onSaved: (v) => nome = v!,
              ),
              TextFormField(
                initialValue: descricao,
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (v) => descricao = v ?? '',
              ),
              TextFormField(
                initialValue: dataAquisicao != null ? dataAquisicao!.toIso8601String().split('T')[0] : '',
                decoration: InputDecoration(labelText: 'Data de aquisição (AAAA-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a data' : null,
                onSaved: (v) => dataAquisicao = DateTime.tryParse(v!),
              ),
              TextFormField(
                initialValue: valor,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Informe o valor' : null,
                onSaved: (v) => valor = v!,
              ),
              TextFormField(
                initialValue: condicao,
                decoration: InputDecoration(labelText: 'Condição (ex: Nova, Usada)'),
                onSaved: (v) => condicao = v ?? '',
              ),
              TextFormField(
                initialValue: detalhesEspecificos,
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fotoController,
                      decoration: InputDecoration(
                        labelText: 'Foto (caminho do arquivo ou URL)',
                        hintText: 'Opcional',
                      ),
                    ),
                  ),
                  // Se quiser permitir seleção de imagem da galeria, descomente o botão abaixo
                  /*
                  IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: _pickImage,
                  ),
                  */
                ],
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
                      fotoPath: fotoController.text.isEmpty ? null : fotoController.text,
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
