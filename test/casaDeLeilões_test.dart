import 'package:flutter_test/flutter_test.dart';
import 'leilao.dart';
import 'casaDeLeiloes.dart';

void main() {
  group("Testes de casa de leilão:", () {
    test("Verifica se os leilões abertos estão sendo filtrados corretamente",
        () {
      Leilao leilao1 = Leilao(
          "Smartphone",
          DateTime.now().subtract(Duration(days: 2)),
          DateTime.now().add(Duration(days: 3)),
          500.0,
          0.0);
      leilao1.defineStatusLeilao(DateTime.now());

      List<Leilao> listaDeLeiloes = [
        leilao1,
      ];
      CasaDeLeiloes csl = CasaDeLeiloes("a", listaDeLeiloes);

      final leiloesAbertos = csl.filtraLeiloes(StatusLeilao.ABERTO);
      expect(leiloesAbertos.length, equals(1));
      expect(leiloesAbertos.first.nomeProduto, equals("Smartphone"));
    });

    test("Verifica se os leilões inativos estão sendo filtrados corretamente",
        () {
      Leilao leilaoInativo = Leilao(
          "Computador",
          DateTime.now().add(Duration(days: 5)),
          DateTime.now().add(Duration(days: 10)),
          1000.0,
          0.0);
      leilaoInativo.defineStatusLeilao(DateTime.now());

      List<Leilao> listaDeLeiloes = [leilaoInativo];
      CasaDeLeiloes csl = CasaDeLeiloes("a", listaDeLeiloes);

      final leiloesInativos = csl.filtraLeiloes(StatusLeilao.INATIVO);
      expect(leiloesInativos.length, equals(1));
      expect(leiloesInativos.first.nomeProduto, equals("Computador"));
    });

    test("Verifica se os leilões expirados estão sendo filtrados corretamente",
        () {
      Leilao leilaoExpirado = Leilao(
          "Guitarra",
          DateTime.now().subtract(Duration(days: 10)),
          DateTime.now().subtract(Duration(days: 5)),
          300.0,
          0.0);
      leilaoExpirado.defineStatusLeilao(DateTime.now());

      List<Leilao> listaDeLeiloes = [leilaoExpirado];
      CasaDeLeiloes csl = CasaDeLeiloes("a", listaDeLeiloes);

      final leiloesExpirados = csl.filtraLeiloes(StatusLeilao.EXPIRADO);
      expect(leiloesExpirados.length, equals(1));
      expect(leiloesExpirados.first.nomeProduto, equals("Guitarra"));
    });

    test(
        "Verifica se os leilões finalizados estão sendo filtrados corretamente",
        () {
      Leilao leilaoFinalizado = Leilao(
          "Bicicleta",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0);
      leilaoFinalizado.defineStatusLeilao(DateTime.now());
      leilaoFinalizado.finalizaLeilao();

      List<Leilao> listaDeLeiloes = [leilaoFinalizado];
      CasaDeLeiloes csl = CasaDeLeiloes("a", listaDeLeiloes);

      final leiloesFinalizados = csl.filtraLeiloes(StatusLeilao.FINALIZADO);
      expect(leiloesFinalizados.length, equals(1));
      expect(leiloesFinalizados.first.nomeProduto, equals("Bicicleta"));
    });
  });
}
