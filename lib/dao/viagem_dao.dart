// import 'package:projeto_avaliacao/database/database_provider.dart';
// import 'package:projeto_avaliacao/model/viagem.dart';

// class ViagemDao {
//   final dbProvider = DatabaseProvider.instance;
//   Future<bool> salvar(Viagem viagem) async {
//     final db = await dbProvider.database;
//     final valores = viagem.toMap();
//     if (viagem.id == null) {
//       viagem.id = await db.insert(Viagem.nome_tabela, valores);
//       return true;
//     } else {
//       final registrosAtualizados = await db.update(Viagem.nome_tabela, valores,
//           where: '${Viagem.campo_id} = ?', whereArgs: [viagem.id]);
//       return registrosAtualizados > 0;
//     }
//   }

//   Future<bool> remover(int id) async {
//     final db = await dbProvider.database;
//     final removerRegistro = await db.delete(Viagem.nome_tabela,
//         where: '${Viagem.campo_id} = ?', whereArgs: [id]);
//     return removerRegistro > 0;
//   }

//   Future<List<Viagem>> Lista() async {
//     final db = await dbProvider.database;
//     final resultado = await db.query(Viagem.nome_tabela,
//         columns: [Viagem.campo_id, Viagem.campo_comentario, Viagem.campo_data]);
//     return resultado.map((m) => Viagem.fromMap(m)).toList();
//   }
// }
