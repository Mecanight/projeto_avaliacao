// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  final localizaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.viagemAtual != null) {
      comentarioController.text = widget.viagemAtual!.comentario;
      dataController.text = widget.viagemAtual!.dataFormatada;
      localizaController.text = widget.viagemAtual!.localiza;
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
              controller: dataController,
              decoration: InputDecoration(
                labelText: 'Data',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _mostraCalendario,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => dataController.clear(),
                ),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: localizaController,
              decoration: InputDecoration(
                labelText: 'Local',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.gps_fixed),
                  onPressed: _obterLocalizacaoAtual,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => localizaController.clear(),
                ),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: comentarioController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: null,
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Descreva a viagem!';
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
      firstDate: data.subtract(const Duration(days: 5 * 365)),
      lastDate: data.add(const Duration(days: 5 * 365)),
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
        id: widget.viagemAtual?.id ?? null,
        comentario: comentarioController.text,
        data: dataController.text.isEmpty
            ? null
            : _dataFormatado.parse(dataController.text),
        localiza: localizaController.text,
      );

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();

    if (!servicoHabilitado) {
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if (!permissoesPermitidas) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(
      () {
        if (position == null) {
          localizaController.text = ('Nenhuma localização encontrada!');
        } else {
          localizaController.text = ('${position.latitude}, ${position.longitude}');
        }
      },
    );
  }

  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        _mostrarMensagem(
            'Não será possível usar o recurso por falta de permissão');
        return false;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem(
          'Para utilizar esse recurso, você deverá acessar as configurações do app e permitir a utilização do serviço de localização');

      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarDialogMensagem(
          'Para utilizar este serviço você precisa habilitar o serviço de localização do dispositivo');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }
}
