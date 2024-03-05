
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