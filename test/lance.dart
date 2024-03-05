import 'cliente.dart';

class Lance {
  int _codigo;
  double _valor;
  Cliente _cliente;

  Lance(this._codigo, this._valor, this._cliente);

  // Getters
  int get codigo => _codigo;
  double get valor => _valor;
  Cliente get cliente => _cliente;

  // Setters
  set codigo(int codigo) => _codigo = codigo;
  set valor(double valor) => _valor = valor;
  set cliente(Cliente cliente) => _cliente = cliente;
}