import 'package:intl/intl.dart';

class Viagem {
  // To Do - ativar quando utilizar o banco
  // static const nome_tabela = 'viagens';
  static const campo_id = '_id';
  static const campo_comentario = 'comentario';
  static const campo_data = 'data';
  static const campo_localiza = 'localiza';

  int id;
  String comentario;
  DateTime? data;
  String localiza;

  Viagem(
      {required this.id,
      required this.comentario,
      required this.data,
      required this.localiza});

  // utilizado para formatar a data
  String get dataFormatada {
    if (data == null) {
      return 'Sem data definida';
    }
    return DateFormat('dd/MM/yyyy').format(data!);
  }

  // To Do - ativar quando utilizar o banco
  // Map<String, dynamic> toMap() => <String, dynamic>{
  //       campo_id: id,
  //       campo_comentario: comentario,
  //       campo_data:
  //           data == null ? null : DateFormat("yyyy-MM-dd").format(data!),
  //     };

  // factory Viagem.fromMap(Map<String, dynamic> map) => Viagem(
  //     id: map[campo_id] is int ? map[campo_id] : null,
  //     comentario: map[campo_comentario] is String ? map[campo_comentario] : '',
  //     data: map[campo_data] is String
  //         ? DateFormat("yyyy-MM-dd").parse(map[campo_data])
  //         : null,
  //     localiza: '' // To Do terminar
  //     );
}
