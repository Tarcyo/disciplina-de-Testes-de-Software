import 'package:flutter_test/flutter_test.dart';
import 'leilao.dart';

void main() {
  group("Testes de leilão:", () {
    test("Verifica se o leilão está aberto", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 1));
      DateTime fim = now.add(Duration(hours: 3));

      Leilao leilao = Leilao('Produto', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.ABERTO));
    });

    test("Verifica se o leilão está inativo", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.add(Duration(hours: 2));
      DateTime fim = now.add(Duration(hours: 15));

      Leilao leilao = Leilao('Produto', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.INATIVO));
    });

    test("Verifica se o leilão está expirado", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 10));
      DateTime fim = now.subtract(Duration(hours: 2));

      Leilao leilao = Leilao('Produto', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);

      expect(leilao.statusLeilao, equals(StatusLeilao.EXPIRADO));
    });

    test("Verifica se o leilão é finalizado corretamente", () {
      DateTime now = DateTime.now();
      DateTime inicio = now.subtract(Duration(hours: 2));
      DateTime fim = now.subtract(Duration(hours: 1));

      Leilao leilao = Leilao('Produto', inicio, fim, 100.0, 0.0);
      leilao.defineStatusLeilao(now);
      leilao.finalizaLeilao();

      expect(leilao.statusLeilao, equals(StatusLeilao.FINALIZADO));
    });
  });
}