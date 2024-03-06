import 'package:flutter_test/flutter_test.dart';
import 'cliente.dart';
import 'lance.dart';
import 'leilao.dart';

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
      expect(leilao.statusLeilao, equals(StatusLeilao.FINALIZADO));
    });
  });
}
