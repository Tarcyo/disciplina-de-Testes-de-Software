import 'package:flutter_test/flutter_test.dart';
import 'model/leilao.dart';
import 'model/lance.dart';
import 'model/participante.dart';
import 'model/servicoEmail.dart';
import 'package:mockito/mockito.dart';

class MockLeilao extends Mock implements Leilao {}

class MockServicoEmail extends Mock implements ServicoEmail {}

void main() {
  group("Testes de leilão:", () {
    test("Verifica se o leilão está aberto", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 1));
      DateTime fim = now.add(Duration(hours: 3));

      Leilao leilao = Leilao("01", 'Jogo', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.ABERTO));
    });

    test("Verifica se o leilão está inativo", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao("01", 'Perfume', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test("Verifica se o leilão está expirado", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 10));
      DateTime fim = now.subtract(Duration(hours: 2));

      Leilao leilao = Leilao("01", 'Poster', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.EXPIRADO));
    });

    test("Verifica se o leilão válido é finalizado corretamente", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 2));
      DateTime fim = now.subtract(Duration(hours: 1));

      Leilao leilao = Leilao("01", 'Mochila', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      ServicoEmail servicoEmail = MockServicoEmail();

      leilao.finalizaLeilao(servicoEmail);

      expect(leilao.statusLeilao, equals(StatusLeilao.FINALIZADO));
    });

    test("Verifica se um leilão invalido não recebe o status de finalizado",
        () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao("01", 'Produto', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      ServicoEmail servicoEmail = MockServicoEmail();

      leilao.finalizaLeilao(servicoEmail);

      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test(
        "Verifica se um leilão invalido não é permitido de ser finalizado corretamente",
        () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao("01", 'Produto', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      ServicoEmail servicoEmail = MockServicoEmail();

      final resultado = leilao.finalizaLeilao(servicoEmail);
      expect(resultado, equals('O leilão não pode ser finalizado!'));
      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test("Verifica se um leilão sem lances é finalizado corretamente", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 2));
      DateTime fim = now.subtract(Duration(hours: 1));
      Leilao leilao = Leilao("01", 'Mochila', inicio, fim, 100.0, 0.0, []);
      leilao.defineStatusLeilao(now);

      ServicoEmail servicoEmail = MockServicoEmail();

      final resultado = leilao.finalizaLeilao(servicoEmail);
      expect(resultado, equals('O leilão não possui lances!'));
      expect(leilao.ganhador, equals(null));
      expect(leilao.statusLeilao, equals(StatusLeilao.FINALIZADO));
    });
  });
  test('Verifica se um leilão com lances está sendo finalizado corretamente.',
      () {
    // Arrange
    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());

    Lance lance1 =
        Lance(1, 120.0, Participante('001', 'João', 'joão@gmail.com'));
    Lance lance2 =
        Lance(2, 150.0, Participante('002', 'Maria', 'maria@gmail.com'));
    Lance lance3 =
        Lance(3, 180.0, Participante('003', 'Pedro', 'pedro@gmail.com'));

    leilao.recebeLance(lance1);
    leilao.recebeLance(lance2);
    leilao.recebeLance(lance3);

    ServicoEmail servicoEmail = MockServicoEmail();

    final resultadoFinal = leilao.finalizaLeilao(servicoEmail);

    expect(leilao.ganhador!.codigo, equals('003'));
    expect(leilao.ganhador!.nome, equals('Pedro'));
    expect(resultadoFinal, equals('email enviado para pedro@gmail.com'));
  });

  test('Verifica se está retornando a lista corretamente', () {
    // Arrange
    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());

    Lance lance1 =
        Lance(1, 120.0, Participante('001', 'João', 'joão@gmail.com'));
    Lance lance2 =
        Lance(2, 150.0, Participante('002', 'Maria', 'maria@gmail.com'));
    Lance lance3 =
        Lance(3, 180.0, Participante('003', 'Pedro', 'pedro@gmail.com'));

    leilao.recebeLance(lance1);
    leilao.recebeLance(lance2);
    leilao.recebeLance(lance3);

    final resultado = leilao.retornaListaDeLances();

    bool emOrdemCrescente = true;
    for (int i = 0; i < leilao.lances.length - 1; i++) {
      if (leilao.lances[i].valor > leilao.lances[i + 1].valor) {
        emOrdemCrescente = false;
        break;
      }
    }

    expect(emOrdemCrescente, isTrue);
    expect(resultado.length, equals(3));
    expect(resultado, const TypeMatcher<List>());
  });

  test('adiciona novo participante lança exceção para código inválido', () {
    Participante participante = Participante('', 'Nome', 'email@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(() => leilao.cadastraNovoParticipante(participante),
        throwsArgumentError);
  });

  test('adiciona novo participante retorna normalmente para código válido', () {
    Participante participante =
        Participante('123456789', 'Nome', 'email@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante), returnsNormally);
  });

  test('adiciona novo participante lança exceção para nome inválido', () {
    // Arrange
    Participante participante = Participante('codigo', '', 'email@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(() => leilao.cadastraNovoParticipante(participante),
        throwsArgumentError);
  });

  test('adiciona novo participante retorna normalmente para nome válido', () {
    // Arrange
    Participante participante =
        Participante('codigo', 'tarcyo', 'email@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante), returnsNormally);
  });

  test('adiciona novo participante lança exceção para email inválido', () {
    // Arrange
    Participante participante = Participante('codigo', 'Nome', 'email');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(() => leilao.cadastraNovoParticipante(participante),
        throwsArgumentError);
  });

  test('adiciona novo participante retorna mormalmente para email válido', () {
    // Arrange
    Participante participante =
        Participante('codigo', 'Nome', 'email@gmail.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante), returnsNormally);
  });
  test('adiciona novo participante lança exceção para código duplicado', () {
    Participante participante1 =
        Participante('codigo', 'Nome1', 'email1@example.com');
    Participante participante2 =
        Participante('codigo', 'Nome2', 'email2@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante1), returnsNormally);

    leilao.defineStatusLeilao(DateTime.now());
    expect(() => leilao.cadastraNovoParticipante(participante2),
        throwsArgumentError);
  });

  test('teste para exceção para email duplicado', () {
    // Arrange
    Participante participante1 =
        Participante('codigo1', 'Nome1', 'email@example.com');
    Participante participante2 =
        Participante('codigo2', 'Nome2', 'email@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante1), returnsNormally);

    leilao.defineStatusLeilao(DateTime.now());
    expect(() => leilao.cadastraNovoParticipante(participante2),
        throwsArgumentError);
  });

  test('teste para permitir emails diferentes', () {
    // Arrange
    Participante participante1 =
        Participante('codigo1', 'Nome1', 'email@example.com');
    Participante participante2 =
        Participante('codigo2', 'Nome2', 'email2@example.com');

    Leilao leilao = Leilao(
        "01",
        'Mesa',
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)),
        100.0,
        0.0, []);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante1), returnsNormally);

    leilao.defineStatusLeilao(DateTime.now());
    expect(
        () => leilao.cadastraNovoParticipante(participante2), returnsNormally);
  });
}
