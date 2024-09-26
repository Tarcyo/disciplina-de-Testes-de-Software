import 'model/CRUDParticipante.dart';
import 'model/participante.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ParticipanteRepository repository;

  setUp(() {
    repository = ParticipanteRepository();
  });

  tearDown(() async {
    var participantes = await repository.listarParticipantes();
    for (var participante in participantes) {
      await repository.removerParticipante(participante.codigo);
    }
  });

  test('Teata se está criando os usuários corretamente', () async {
    var participante1 = Participante('001', 'João Silva', 'joao.silva@example.com');
    var participante2 = Participante('002', 'Maria Souza', 'maria.souza@example.com');
    var participante3 = Participante('003', 'Pedro Santos', 'pedro.santos@example.com');

    await repository.criarParticipante(participante1);
    await repository.criarParticipante(participante2);
    await repository.criarParticipante(participante3);

    var participanteCriado1 = await repository.obterParticipante('001');
    var participanteCriado2 = await repository.obterParticipante('002');
    var participanteCriado3 = await repository.obterParticipante('003');

    // Verifica se os participantes foram criados corretamente
    expect(participanteCriado1?.nome, equals('João Silva'));
    expect(participanteCriado2?.nome, equals('Maria Souza'));
    expect(participanteCriado3?.nome, equals('Pedro Santos'));
  });

  test('Listagem de usuários - deve conter pelo menos 3 usuários', () async {
    // Adiciona 3 usuários
    var participante1 = Participante('001', 'João Silva', 'joao.silva@example.com');
    var participante2 = Participante('002', 'Maria Souza', 'maria.souza@example.com');
    var participante3 = Participante('003', 'Pedro Santos', 'pedro.santos@example.com');

    await repository.criarParticipante(participante1);
    await repository.criarParticipante(participante2);
    await repository.criarParticipante(participante3);

    // Obtem todos os usuários
    var participantes = await repository.listarParticipantes();

    // Verifica se há pelo menos 3 usuários
    expect(participantes.length, greaterThanOrEqualTo(3));

    // Verifica se os usuários criados estão presentes na lista
    var codigos = participantes.map((p) => p.codigo).toList();
    expect(codigos, containsAll(['001', '002', '003']));
  });

  test('Edição de usuário', () async {
    var participante = Participante('001', 'João Alterado', 'joao.alterado@example.com');
    await repository.editarParticipante(participante);

    var participanteEditado = await repository.obterParticipante('001');
    expect(participanteEditado?.nome, equals('João Alterado'));
  });

  test('Obter usuário', () async {
    var participante = await repository.obterParticipante('001');
    expect(participante?.nome, equals('João Silva'));
  });
}