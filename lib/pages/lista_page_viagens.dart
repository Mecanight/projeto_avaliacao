import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:projeto_avaliacao/dao/viagem_dao.dart';
import 'package:projeto_avaliacao/model/viagem.dart';
import 'package:projeto_avaliacao/pages/filtro_page.dart';
import 'package:projeto_avaliacao/widgets/conteudo_form_dialog.dart';

class ListaViagemPage extends StatefulWidget {
  @override
  _ListaViagemPageState createState() => _ListaViagemPageState();
}

class _ListaViagemPageState extends State<ListaViagemPage> {
  final _viagens = <Viagem>[];

  // final _dao = ViagemDao(); // To Do - para banco ativar
  var _ultimoId = 0; // To Do - para banco eliminar

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

// To Do - para banco ativar
  // void initstate() {
  //   super.initState();
  //   _atualizarLista();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(context),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        child: Icon(Icons.add),
        tooltip: 'Nova Viagem',
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text('Viagens'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _abrirFiltro,
          icon: const Icon(
            Icons.filter_list,
          ),
          // alignment: Alignment.topLeft,
        )
      ],
    );
  }

  Widget _criarBody() {
    if (_viagens.isEmpty) {
      return Center(
        child: Container(
          // alignment: Alignment.topCenter,
          // padding: const EdgeInsets.only(top: 120),
          child: const Text(
            'Sem viagens por enquanto!',
            style: TextStyle(
              fontSize: 25,
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
            color: Color.fromARGB(255, 162, 240, 168), // Cor de fundo do container
            borderRadius: BorderRadius.circular(20), // Bordas arredondadas
          ),
          child: PopupMenuButton<String>(
            child: ListTile(
              title: Text(
                  '${viagem.id}     ${viagem.localiza == '' ? 'Sem local definido' : viagem.localiza}     ${viagem.dataFormatada}'),
              subtitle: Text('${viagem.comentario}'),
            ),
            itemBuilder: (BuildContext context) => criarItensMenuPopUp(),
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EDITAR) {
                _abrirForm(
                    viagemAtual: viagem,
                    indice:
                        index); // To Do - para banco eliminar "indice: index"
              } else {
                _excluir(index /*To Do - p/ banco substituir por "viagem"*/);
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
          //implementação de filtro
        }
      },
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopUp() {
    return [
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

  Future _excluir(
      int indice /*To Do - p/ banco substituir por "Viagem viagem"*/) {
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
                  setState(
                    () {
                      _viagens.removeAt(indice);
                    },
                  );

                  // To Do - para banco ativar
                  // if (viagem.id == null) {
                  //   return;
                  // }
                  // _dao.remover(viagem.id!).then((success) {
                  //   if (success) {
                  //     _atualizarLista();
                  //   }
                  // });
                },
                child: Text('Ok')),
          ],
        );
      },
    );
  }

  void _abrirForm({Viagem? viagemAtual, int? indice}) {
    // To Do - para banco eliminar "int? indice"
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
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (key.currentState!.dadosValidados() &&
                    key.currentState != null) {
                  setState(
                    () {
                      final novaViagem = key.currentState!.novaViagem;
                      if (indice == null) {
                        //eliminar
                        novaViagem.id = ++_ultimoId; //eliminar
                        _viagens.add(novaViagem); //eliminar
                      } else {
                        //eliminar
                        _viagens[indice] = novaViagem; //eliminar
                      } //eliminar

                      // To Do - para banco ativar \/ e eliminar /\
                      // _dao.salvar(novaViagem).then((success) {
                      //   if (success) {
                      //     _atualizarLista();
                      //   }
                      // });
                    },
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            )
          ],
        );
      },
    );
  }
  // To Do - para banco ativar
  // void _atualizarLista() async {
  //   final viagens = await _dao.Lista();
  //   setState(() {
  //     _viagens.clear();
  //     if (viagens.isNotEmpty) {
  //       _viagens.addAll(viagens);
  //     }
  //   });
  // }
}
