import 'conexaoBancoDeDados.dart';
import 'participante.dart';

class ParticipanteRepository {
  Future<void> criarParticipante(Participante participante) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.query(
          'INSERT INTO participantes (codigo, nome, email) VALUES (?, ?, ?)', 
          [participante.codigo, participante.nome, participante.email]);
      print("Usuário criado com sucesso!");
    } finally {
      await conn.close();
    }
  }

  Future<void> editarParticipante(Participante participante) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.query(
          'UPDATE participantes SET nome = ?, email = ? WHERE codigo = ?', 
          [participante.nome, participante.email, participante.codigo]);
      print("Usuário editado com sucesso!");
    } finally {
      await conn.close();
    }
  }

  Future<Participante?> obterParticipante(String codigo) async {
    final conn = await DBConnection.getConnection();
    try {
      var results = await conn.query('SELECT codigo, nome, email FROM participantes WHERE codigo = ?', [codigo]);

      if (results.isNotEmpty) {
        var row = results.first;
        return Participante(row['codigo'], row['nome'], row['email']);
      }
    } finally {
      await conn.close();
    }
    return null;
  }

  Future<List<Participante>> listarParticipantes() async {
    final conn = await DBConnection.getConnection();
    List<Participante> participantes = [];
    try {
      var results = await conn.query('SELECT codigo, nome, email FROM participantes');
      for (var row in results) {
        participantes.add(Participante(row['codigo'], row['nome'], row['email']));
      }
    } finally {
      await conn.close();
    }
    return participantes;
  }

  // Função para remover um participante pelo código
  Future<void> removerParticipante(String codigo) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.query('DELETE FROM participantes WHERE codigo = ?', [codigo]);
      print("Usuário removido com sucesso!");
    } finally {
      await conn.close();
    }
  }
}