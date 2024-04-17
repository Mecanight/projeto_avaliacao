import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/viagem.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Viagem? viagemAtual;

  ConteudoFormDialog({Key? key, this.viagemAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final formKey = GlobalKey<FormState>();
  final comentarioController = TextEditingController();
  final dataController = TextEditingController();
  final _dataFormatado = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.viagemAtual != null) {
      comentarioController.text = widget.viagemAtual!.comentario;
      dataController.text = widget.viagemAtual!.dataFormatada;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Localização',
                prefixIcon: IconButton(
                  icon: Icon(Icons.gps_fixed),
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {},
                ),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: dataController,
              decoration: InputDecoration(
                labelText: 'Data',
                prefixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _mostraCalendario,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => dataController.clear(),
                ),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: comentarioController,
              decoration: InputDecoration(labelText: 'Comentário'),
              maxLines: null,
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe o Comentário!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostraCalendario() {
    final dataFormatada = dataController.text;
    var data = DateTime.now();

    if (dataFormatada.isNotEmpty) {
      data = _dataFormatado.parse(dataFormatada);
    }
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days: 5 * 365)),
      lastDate: data.add(Duration(days: 5 * 365)),
    ).then(
      (DateTime? dataSelecionada) {
        if (dataSelecionada != null) {
          setState(
            () {
              dataController.text = _dataFormatado.format(dataSelecionada);
            },
          );
        }
      },
    );
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Viagem get novaViagem => Viagem(
      id: widget.viagemAtual?.id ?? 0,
      comentario: comentarioController.text,
      data: dataController.text.isEmpty
          ? null
          : _dataFormatado.parse(dataController.text),
      localiza: '' //To Do terminar essa parte
      );
}
