import 'package:flutter_test/flutter_test.dart';

enum StatusLeilao {
  ABERTO,
  FINALIZADO,
  EXPIRADO,
  INATIVO,
}

class Leilao {
  String _nomeProduto;
  DateTime _inicio;
  DateTime _fim;
  double _lanceMinimo;
  double _lanceAtual;
  StatusLeilao? _statusLeilao;

  Leilao(this._nomeProduto, this._inicio, this._fim, this._lanceMinimo,
      this._lanceAtual);

  // Getters
  String get nomeProduto => _nomeProduto;
  DateTime get inicio => _inicio;
  DateTime get fim => _fim;
  double get lanceMinimo => _lanceMinimo;
  double get lanceAtual => _lanceAtual;
  StatusLeilao? get statusLeilao => _statusLeilao;

  // Setters
  set nomeProduto(String nomeProduto) => _nomeProduto = nomeProduto;
  set inicio(DateTime inicio) => _inicio = inicio;
  set fim(DateTime fim) => _fim = fim;
  set lanceMinimo(double lanceMinimo) => _lanceMinimo = lanceMinimo;
  set lanceAtual(double lanceAtual) => _lanceAtual = lanceAtual;
  set statusLeilao(StatusLeilao? statusLeilao) => _statusLeilao = statusLeilao;

  defineStatusLeilao(DateTime now) {
    if (_inicio.isBefore(now) && now.isBefore(_fim)) {
      _statusLeilao = StatusLeilao.ABERTO;
    } else if (now.isBefore(_inicio)) {
      _statusLeilao = StatusLeilao.INATIVO;
    } else if (now.isAfter(_fim)) {
      _statusLeilao = StatusLeilao.EXPIRADO;
    }
  }

  finalizaLeilao() {
    if (_statusLeilao == StatusLeilao.ABERTO ||
        _statusLeilao == StatusLeilao.EXPIRADO) {
      _statusLeilao = StatusLeilao.FINALIZADO;
    }
  }
}

class CasaDeLeiloes {
  String _codigo;
  List<Leilao> _leiloes;

  CasaDeLeiloes(this._codigo, this._leiloes);

  // Getters
  String get codigo => _codigo;
  List<Leilao> get leiloes => _leiloes;

  // Setters
  set codigo(String codigo) => _codigo = codigo;
  set leiloes(List<Leilao> leiloes) => _leiloes = leiloes;

  List<Leilao> filtraLeiloes(StatusLeilao status) {
    return _leiloes.where((leilao) => leilao.statusLeilao == status).toList();
  }
}

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
