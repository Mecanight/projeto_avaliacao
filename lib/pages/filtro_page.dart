import 'package:flutter/material.dart';
import 'package:projeto_avaliacao/model/viagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const CHAVE_ORDENAR_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_COMENTARIO = 'filtroComentario';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

@override
class _FiltroPageState extends State<FiltroPage> {
  final camposParaOrdenacao = {
    Viagem.campo_id: 'Código',
    Viagem.campo_comentario: 'Comentario',
    Viagem.campo_data: 'Data',
    Viagem.campo_localiza: "Localização"
  };

  late final SharedPreferences prefs;
  final _comentarioController = TextEditingController();
  String _campoOrdenacao = Viagem.campo_id;
  bool _usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _campoOrdenacao = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ??
            Viagem.campo_id;
        _usarOrdemDecrescente =
            prefs.getBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE) ?? false;
        _comentarioController.text =
            prefs.getString(FiltroPage.CHAVE_FILTRO_COMENTARIO) ?? '';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onVoltarClick,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: const Text('Filtro e Ordenação')),
        body: _criarBody(),
      ),
    );
  }

  Widget _criarBody() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campos para ordenação'),
        ),
        for (final campo in camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _campoOrdenacao,
                onChanged: _onCampoOrdenacaoChanged,
              ),
              Text(camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        const Divider(),
        Row(
          children: [
            Checkbox(
              value: _usarOrdemDecrescente,
              onChanged: _onUsarOrdemDecrescenteChange,
            ),
            const Text('Usar ordem decrescente')
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration:
                const InputDecoration(labelText: 'O comentário começa com:'),
            controller: _comentarioController,
            onChanged: _onFiltroDComentarioChange,
          ),
        ),
      ],
    );
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onCampoOrdenacaoChanged(String? valor) {
    prefs.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    _alterouValores = true;
    setState(
      () {
        _campoOrdenacao = valor ?? '';
      },
    );
  }

  void _onUsarOrdemDecrescenteChange(bool? valor) {
    prefs.setBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE, valor == true);
    _alterouValores = true;
    setState(
      () {
        _usarOrdemDecrescente = valor == true;
      },
    );
  }

  void _onFiltroDComentarioChange(String? valor) {
    prefs.setString(FiltroPage.CHAVE_FILTRO_COMENTARIO, valor ?? '');
    _alterouValores = true;
  }
}
