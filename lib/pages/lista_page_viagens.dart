import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_avaliacao/dao/viagem_dao.dart';
import 'package:projeto_avaliacao/model/viagem.dart';
import 'package:projeto_avaliacao/pages/datalhe_viagem_page.dart';
import 'package:projeto_avaliacao/pages/filtro_page.dart';
import 'package:projeto_avaliacao/widgets/conteudo_form_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaViagemPage extends StatefulWidget {
  @override
  _ListaViagemPageState createState() => _ListaViagemPageState();
}

class _ListaViagemPageState extends State<ListaViagemPage> {
  final _viagens = <Viagem>[];

  final _dao = ViagemDao();
  var _carregando = false;

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZAR = 'visualizar';

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {
    setState(
      () {
        _carregando = true;
      },
    );

    final prefs = await SharedPreferences.getInstance();
    final _campoOrdenacao =
        prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? Viagem.campo_id;
    final _usarOrdemDecrescente =
        prefs.getBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE) == true;
    final _filtroComentario =
        prefs.getString(FiltroPage.CHAVE_FILTRO_COMENTARIO) ?? '';

    final viagens = await _dao.Lista(
      filtro: _filtroComentario,
      campoOrdenacao: _campoOrdenacao,
      usarOrdemDecrescente: _usarOrdemDecrescente,
    );

    setState(
      () {
        _viagens.clear();
        // if (viagens.isNotEmpty || viagens.isEmpty) {
        _carregando = false;
        _viagens.addAll(viagens);
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(context),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Nova Viagem',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: const Text('Viagens'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _abrirFiltro,
          icon: const Icon(
            Icons.filter_list,
          ),
        )
      ],
    );
  }

  Widget _criarBody() {
    if (_carregando) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando seus diários de Viagem!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      );
    }
    if (_viagens.isEmpty) {
      return Center(
        child: Container(
          child: const Text(
            'Sem viagens por enquanto!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        final viagem = _viagens[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 162, 240, 168),
            borderRadius: BorderRadius.circular(20),
          ),
          child: PopupMenuButton<String>(
            child: ListTile(
              title: Text(
                  '${viagem.id}   Data: ${viagem.dataFormatada}\nLocal: ${viagem.localiza == '' ? 'Sem local definido' : viagem.localiza}'),
              subtitle: Text('Descrição: ${viagem.comentario}'),
            ),
            itemBuilder: (BuildContext context) => criarItensMenuPopUp(),
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EDITAR) {
                _abrirForm(viagemAtual: viagem);
              } else if (valorSelecionado == ACAO_EXCLUIR) {
                _excluir(viagem);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetalheViagemPage(viagem: viagem),
                  ),
                );
              }
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.black,
      ),
      itemCount: _viagens.length,
    );
  }

  void _abrirFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then(
      (alterouValor) {
        if (alterouValor == true) {
          _atualizarLista();
        }
      },
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopUp() {
    return [
      const PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Visualizar'),
            )
          ],
        ),
      ),
      const PopupMenuItem(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            )
          ],
        ),
      ),
      const PopupMenuItem(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )
          ],
        ),
      ),
    ];
  }

  Future _excluir(Viagem viagem) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning,
                color: Color.fromARGB(255, 121, 15, 7),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Atenção',
                  style: TextStyle(color: Color.fromARGB(255, 121, 15, 7)),
                ),
              )
            ],
          ),
          content: const Text('Esse diário será deletado definitivamente!'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (viagem.id == null) {
                  return;
                }
                _dao.remover(viagem.id!).then(
                  (success) {
                    if (success) {
                      _atualizarLista();
                    }
                  },
                );
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _abrirForm({Viagem? viagemAtual}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(viagemAtual == null
              ? 'Nova Viagem'
              : 'Alterar Viagem ${viagemAtual.id}'),
          content: ConteudoFormDialog(key: key, viagemAtual: viagemAtual),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (key.currentState!.dadosValidados() &&
                    key.currentState != null) {
                  setState(
                    () {
                      final novaViagem = key.currentState!.novaViagem;
                      _dao.salvar(novaViagem).then(
                        (success) {
                          if (success) {
                            _atualizarLista();
                          }
                        },
                      );
                    },
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            )
          ],
        );
      },
    );
  }
}
