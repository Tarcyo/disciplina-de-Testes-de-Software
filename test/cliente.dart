class Cliente {
  String _codigo;
  String _nome;

  // Construtor
  Cliente(this._codigo, this._nome);

  // Getters
  String get codigo => _codigo;
  String get nome => _nome;

  // Setters
  set codigo(String codigo) => _codigo = codigo;
  set nome(String nome) => _nome = nome;
}
