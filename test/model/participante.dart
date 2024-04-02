class Participante {
  String _codigo;
  String _nome;
  String _email;

  // Construtor
  Participante(this._codigo, this._nome,this._email);

  // Getters
  String get codigo => _codigo;
  String get nome => _nome;
  String get email => _email;
  // Setters
  set codigo(String codigo) => _codigo = codigo;
  set nome(String nome) => _nome = nome;
  set email(String email)=> _email=email;

}
