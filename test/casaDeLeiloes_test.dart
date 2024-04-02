import 'package:flutter_test/flutter_test.dart';
import 'model/leilao.dart';
import 'model/casaDeLeiloes.dart';
import 'package:mockito/mockito.dart';
import 'model/registroLeilao.dart';
import 'model/servicoEmail.dart';

class MockRegistroLeilao extends Mock implements RegistroLeilao {}

class MockServicoEmail extends Mock implements ServicoEmail {}

void main() {
  group("Testes de casa de leilão:", () {
    test("Verifica se os leilões abertos estão sendo filtrados corretamente",
        () {
      Leilao leilao1 = Leilao(
          "01",
          "Smartphone",
          DateTime.now().subtract(Duration(days: 2)),
          DateTime.now().add(Duration(days: 3)),
          500.0,
          0.0, []);
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
          "01",
          "Computador",
          DateTime.now().add(Duration(days: 5)),
          DateTime.now().add(Duration(days: 10)),
          1000.0,
          0.0, []);
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
          "01",
          "Guitarra",
          DateTime.now().subtract(Duration(days: 10)),
          DateTime.now().subtract(Duration(days: 5)),
          300.0,
          0.0, []);
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
          "01",
          "Bicicleta",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      leilaoFinalizado.defineStatusLeilao(DateTime.now());

      ServicoEmail servicoEmail = MockServicoEmail();

      leilaoFinalizado.finalizaLeilao(servicoEmail);

      List<Leilao> listaDeLeiloes = [leilaoFinalizado];
      CasaDeLeiloes csl = CasaDeLeiloes("a", listaDeLeiloes);

      final leiloesFinalizados = csl.filtraLeiloes(StatusLeilao.FINALIZADO);
      expect(leiloesFinalizados.length, equals(1));
      expect(leiloesFinalizados.first.nomeProduto, equals("Bicicleta"));
    });

    test("Verifica se não está aceitando um leilão com nome inválido.", () {
      Leilao leilao = Leilao(
          "01",
          "",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      leilao.defineStatusLeilao(DateTime.now());

      CasaDeLeiloes csl = CasaDeLeiloes("0123", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      expect(() => csl.adicionaNovoLeilao(leilao, registroleilao),
          throwsA(isA<ArgumentError>()));
    });

    test("Verifica se está aceitando um leilão com nome válido.", () {
      Leilao leilao = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      leilao.defineStatusLeilao(DateTime.now());

      CasaDeLeiloes csl = CasaDeLeiloes("0123", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      expect(() => csl.adicionaNovoLeilao(leilao, registroleilao),
          returnsNormally);
    });

    test("Verifica se não está aceitando um leilao com código igual", () {
      // Arrange
      Leilao leilao1 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      Leilao leilao2 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      CasaDeLeiloes cls = CasaDeLeiloes("01", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      cls.adicionaNovoLeilao(leilao1, registroleilao);
      // Act & Assert
      expect(() => cls.adicionaNovoLeilao(leilao2, registroleilao),
          throwsArgumentError);
    });

    test("Verifica se está aceitando um leilao com código diferente", () {
      // Arrange
      Leilao leilao1 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      Leilao leilao2 = Leilao(
          "02",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      CasaDeLeiloes cls = CasaDeLeiloes("01", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      cls.adicionaNovoLeilao(leilao1, registroleilao);
      // Act & Assert
      expect(() => cls.adicionaNovoLeilao(leilao2, registroleilao),
          returnsNormally);
    });

    test("Verifica se não está removendo se não for um leilão já registrado",
        () {
      // Arrange
      Leilao leilao1 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      Leilao leilao2 = Leilao(
          "02",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      Leilao leilao3 = Leilao(
          "03",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      CasaDeLeiloes cls = CasaDeLeiloes("01", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      cls.adicionaNovoLeilao(leilao1, registroleilao);

      cls.adicionaNovoLeilao(leilao2, registroleilao);
      // Act & Assert
      expect(
          () => cls.removeLeilao(leilao3, registroleilao), throwsArgumentError);
    });

    test("Verifica se está removendo se for um leilao registrado", () {
      // Arrange
      Leilao leilao1 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      Leilao leilao2 = Leilao(
          "02",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      CasaDeLeiloes cls = CasaDeLeiloes("01", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      cls.adicionaNovoLeilao(leilao1, registroleilao);
      cls.adicionaNovoLeilao(leilao2, registroleilao);
      // Act & Assert
      expect(() => cls.removeLeilao(leilao2, registroleilao), returnsNormally);
    });

    test("Verifica se não está atualizando se não for um leilão já registrado",
        () {
      // Arrange
      Leilao leilao1 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      Leilao leilao2 = Leilao(
          "02",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      Leilao leilao3 = Leilao(
          "03",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      CasaDeLeiloes cls = CasaDeLeiloes("01", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      cls.adicionaNovoLeilao(leilao1, registroleilao);

      cls.adicionaNovoLeilao(leilao2, registroleilao);
      // Act & Assert
      expect(() => cls.atualizaLeilao(leilao3, registroleilao),
          throwsArgumentError);
    });

    test("Verifica se está atualizando se for um leilao registrado", () {
      // Arrange
      Leilao leilao1 = Leilao(
          "01",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);
      Leilao leilao2 = Leilao(
          "02",
          "a",
          DateTime.now().subtract(Duration(days: 15)),
          DateTime.now().subtract(Duration(days: 10)),
          700.0,
          0.0, []);

      CasaDeLeiloes cls = CasaDeLeiloes("01", []);

      RegistroLeilao registroleilao = MockRegistroLeilao();

      cls.adicionaNovoLeilao(leilao1, registroleilao);
      cls.adicionaNovoLeilao(leilao2, registroleilao);
      // Act & Assert
      expect(
          () => cls.atualizaLeilao(leilao2, registroleilao), returnsNormally);
    });
  });
}
