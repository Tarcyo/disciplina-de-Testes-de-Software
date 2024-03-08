import 'package:flutter_test/flutter_test.dart';
import 'leilao.dart';
import 'lance.dart';
import 'participante.dart';

void main() {
  group("Testes de leilão:", () {
    test("Verifica se o leilão está aberto", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 1));
      DateTime fim = now.add(Duration(hours: 3));

      Leilao leilao = Leilao('Jogo', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.ABERTO));
    });

    test("Verifica se o leilão está inativo", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao('Perfume', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test("Verifica se o leilão está expirado", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 10));
      DateTime fim = now.subtract(Duration(hours: 2));

      Leilao leilao = Leilao('Poster', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.EXPIRADO));
    });

    test("Verifica se o leilão válido é finalizado corretamente", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 2));
      DateTime fim = now.subtract(Duration(hours: 1));

      Leilao leilao = Leilao('Mochila', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);
      leilao.finalizaLeilao();

      expect(leilao.statusLeilao, equals(StatusLeilao.FINALIZADO));
    });

    test("Verifica se um leilão invalido não recebe o status de finalizado",
        () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao('Produto', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);
      leilao.finalizaLeilao();

      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test(
        "Verifica se um leilão invalido não é permitido de ser finalizado corretamente",
        () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao('Produto', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);
      final resultado = leilao.finalizaLeilao();
      expect(resultado, equals('O leilão não pode ser finalizado!'));
      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test("Verifica se um leilão sem lances é finalizado corretamente", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 2));
      DateTime fim = now.subtract(Duration(hours: 1));
      Leilao leilao = Leilao('Mochila', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);
      final resultado = leilao.finalizaLeilao();
      expect(resultado, equals('O leilão não possui lances!'));
      expect(leilao.ganhador, equals(null));
      expect(leilao.statusLeilao, equals(StatusLeilao.FINALIZADO));
    });
  });
  test('Verifica se um leilão com lances está sendo finalizado corretamente.',
      () {
    // Arrange
    Leilao leilao = Leilao('Mesa', DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)), 100.0, 0.0);

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
    final resultadoFinal = leilao.finalizaLeilao();

    expect(leilao.ganhador!.codigo, equals('003'));
    expect(leilao.ganhador!.nome, equals('Pedro'));
    expect(resultadoFinal, equals('email enviado para pedro@gmail.com'));
  });

  test('Verifica se está retornando a lista corretamente', () {
    // Arrange
    Leilao leilao = Leilao('Mesa', DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().add(Duration(days: 1)), 100.0, 0.0);

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
}
