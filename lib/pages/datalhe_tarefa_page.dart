import 'package:flutter/material.dart';
import 'package:projeto_avaliacao/model/viagem.dart';

class DetalheViagemPage extends StatefulWidget {
  final Viagem viagem;

  const DetalheViagemPage({Key? key, required this.viagem}) : super(key: key);

  @override
  DetalheViagemPageState createState() => DetalheViagemPageState();
}

class DetalheViagemPageState extends State<DetalheViagemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Detalhes da Viagem'),
        centerTitle: false,
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            children: [
              const Campo(descricao: 'Código:'),
              Valor(valor: '${widget.viagem.id}'),
            ],
          ),
          Row(
            children: [
              const Campo(descricao: 'Cometário:'),
              Valor(valor: '${widget.viagem.comentario}'),
            ],
          ),
          Row(
            children: [
              const Campo(descricao: 'Data:'),
              Valor(valor: '${widget.viagem.dataFormatada}'),
            ],
          ),
          Row(
            children: [
              const Campo(descricao: 'Localização:'),
              Valor(valor: '${widget.viagem.localiza}'),
            ],
          ),
        ],
      ),
    );
  }
}

class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        descricao,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor == '' ? 'Sem valor' : valor),
    );
  }
}
