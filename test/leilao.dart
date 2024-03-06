import 'lance.dart';

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
  double _valorLanceMinimo;
  List<Lance> _lances = [];
  double _lanceAtual;
  StatusLeilao? _statusLeilao;

  Leilao(this._nomeProduto, this._inicio, this._fim, this._valorLanceMinimo,
      this._lanceAtual);

  // Getters
  String get nomeProduto => _nomeProduto;
  DateTime get inicio => _inicio;
  DateTime get fim => _fim;
  double get lanceMinimo => _valorLanceMinimo;
  double get lanceAtual => _lanceAtual;
  StatusLeilao? get statusLeilao => _statusLeilao;
  List<Lance> get lances => _lances;
  // Setters
  set nomeProduto(String nomeProduto) => _nomeProduto = nomeProduto;
  set inicio(DateTime inicio) => _inicio = inicio;
  set fim(DateTime fim) => _fim = fim;
  set lanceMinimo(double lanceMinimo) => _valorLanceMinimo = lanceMinimo;
  set lanceAtual(double lanceAtual) => _lanceAtual = lanceAtual;
  set statusLeilao(StatusLeilao? statusLeilao) => _statusLeilao = statusLeilao;
  set lances(List<Lance> lances) => _lances;

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
      if (lances.isEmpty) {
        _statusLeilao = StatusLeilao.FINALIZADO;
        return 'O leilão não possui lances!';
      }
    } else {
      return 'O leilão não pode ser finalizado!';
    }
  }

  String recebeLance(Lance lance) {
    if (_statusLeilao != StatusLeilao.ABERTO) {
      return 'O leilão não está aberto e não pode receber lances!';
    }

    if (lance.valor < lanceMinimo) {
      return 'O lance é menor que o lance mínimo!';
    }

    if (_lances.isNotEmpty && lance.valor <= _lances.last.valor) {
      return 'O lance deve ser maior ao último lance!';
    }

    if (_lances.isNotEmpty &&
        lance.cliente.codigo == _lances.last.cliente.codigo) {
      return 'O mesmo cliente não pode fazer um lance duas vezes seguidas!';
    }

    _lances.add(lance);
    return 'Lance aceito!';
  }
}
