import 'participante.dart';

class Lance {
  int _codigo;
  double _valor;
  Participante _cliente;

  Lance(this._codigo, this._valor, this._cliente);

  // Getters
  int get codigo => _codigo;
  double get valor => _valor;
  Participante get cliente => _cliente;

  // Setters
  set codigo(int codigo) => _codigo = codigo;
  set valor(double valor) => _valor = valor;
  set cliente(Participante cliente) => _cliente = cliente;
}