import 'leilao.dart';
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
}