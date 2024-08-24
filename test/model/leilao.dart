import 'participante.dart';
import 'lance.dart';
import 'servicoEmail.dart';

enum StatusLeilao {
  ABERTO,
  FINALIZADO,
  EXPIRADO,
  INATIVO,
}

class Leilao {
  String _codigo;
  String _nomeProduto;
  DateTime _inicio;
  DateTime _fim;
  double _valorLanceMinimo;
  List<Participante> participantes = [];
  List<Lance> _lances = [];
  double _lanceAtual;
  StatusLeilao? _statusLeilao;
  Participante? _ganhador;

  Leilao(this._codigo, this._nomeProduto, this._inicio, this._fim,
      this._valorLanceMinimo, this._lanceAtual, this.participantes);

  // Getters
  String get nomeProduto => _nomeProduto;
  String get codigo => _codigo;
  DateTime get inicio => _inicio;
  DateTime get fim => _fim;
  double get lanceMinimo => _valorLanceMinimo;
  double get lanceAtual => _lanceAtual;
  StatusLeilao? get statusLeilao => _statusLeilao;
  List<Lance> get lances => _lances;
  Participante? get ganhador => _ganhador;
  // Setters
  set nomeProduto(String nomeProduto) => _nomeProduto = nomeProduto;
  set codigo(String codigo) => _codigo = codigo;
  set inicio(DateTime inicio) => _inicio = inicio;
  set fim(DateTime fim) => _fim = fim;
  set lanceMinimo(double lanceMinimo) => _valorLanceMinimo = lanceMinimo;
  set lanceAtual(double lanceAtual) => _lanceAtual = lanceAtual;
  set statusLeilao(StatusLeilao? statusLeilao) => _statusLeilao = statusLeilao;
  set lances(List<Lance> lances) => _lances;

  //Número 2, 3 e 4
  defineStatusLeilao(DateTime now) {
    if (_inicio.isBefore(now) && now.isBefore(_fim)) {
      _statusLeilao = StatusLeilao.ABERTO;
    } else if (now.isBefore(_inicio)) {
      _statusLeilao = StatusLeilao.INATIVO;
    } else if (now.isAfter(_fim)) {
      _statusLeilao = StatusLeilao.EXPIRADO;
    }
  }

  //Número 5 e 6
  String finalizaLeilao(ServicoEmail servicoEmail) {
    if (_statusLeilao == StatusLeilao.ABERTO ||
        _statusLeilao == StatusLeilao.EXPIRADO) {
      if (lances.isEmpty) {
        _statusLeilao = StatusLeilao.FINALIZADO;
        return 'O leilão não possui lances!';
      } else {
        _ganhador = lances.last.cliente;
        servicoEmail.enviaEmail(this);
        return 'email enviado para ' + _ganhador!.email.toString();
      }
    } else {
      return 'O leilão não pode ser finalizado!';
    }
  }

  //Número 7, 8 e 9
  String recebeLance(Lance lance) {
    if (lance.valor <= 0) {
      throw ArgumentError('O leilão deve ser maior que 0!');
    }
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

  // Número 10
  void cadastraNovoParticipante(Participante participante) {
    if (participante.codigo.isEmpty) {
      throw ArgumentError('Código de participante inválido.');
    }

    if (participante.nome.isEmpty) {
      throw ArgumentError('Nome de participante inválido.');
    }

    if (participante.email.isEmpty) {
      throw ArgumentError('Email de participante inválido.');
    } else if (!_validarEmail(participante.email)) {
      throw ArgumentError('Email de participante inválido.');
    }

    if (participantes.any((p) => p.codigo == participante.codigo)) {
      throw ArgumentError('Já existe um usuário com o mesmo código.');
    }

    if (participantes.any((p) => p.email == participante.email)) {
      throw ArgumentError('Já existe um usuário com o mesmo email.');
    }

    participantes.add(participante);
  }

  //Número 11
  List<Lance> retornaListaDeLances() {
    return lances;
  }

  //Número 12
  Lance retornaMaiorLance() {
    return _lances.last;
  }

  Lance retornaMenorLance() {
    return _lances[0];
  }

  bool _validarEmail(String email) {
    // Expressão regular para validar email
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
