import 'leilao.dart';
import 'registroLeilao.dart';

class CasaDeLeiloes {
  List<Leilao> _leiloes;
  String codigo;

  CasaDeLeiloes(this.codigo, this._leiloes);

  // Getters
  List<Leilao> get leiloes => _leiloes;


   //Número 1
   List<Leilao> filtraLeiloes(StatusLeilao status) {
    return _leiloes.where((leilao) => leilao.statusLeilao == status).toList();
  }

  void adicionaNovoLeilao(Leilao leilao, RegistroLeilao registroLeilao) {
    if (leilao.nomeProduto == "") {
      throw ArgumentError('O leilão não tem um nome válido');
    }
    if (leiloes.any((l) => l.codigo == leilao.codigo)) {
      throw ArgumentError('Já existe um usuário com o mesmo código.');
    }

    leiloes.add(leilao);
    registroLeilao.registraLeilaoNoBancoDeDados(leilao);
  }

  void removeLeilao(Leilao leilao, RegistroLeilao registroLeilao) {
    for (int i = 0; i < _leiloes.length; i++) {
      if (_leiloes[i].codigo == leilao.codigo) {
        _leiloes.removeAt(i);
        return;
      }
    }
    throw ArgumentError('Não é possível remover o leilao!');
  }

  void atualizaLeilao(
      Leilao leilao, RegistroLeilao registroLeilao) {
    for (int i = 0; i < _leiloes.length; i++) {
      if (_leiloes[i].codigo == leilao.codigo) {
        _leiloes[i] = leilao;
        return;
      }
    }
    throw ArgumentError('Não é possível atualizar o leilao!');
  }

 
}
