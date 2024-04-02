import 'leilao.dart';

class RegistroLeilao {
  List<Leilao> _leiloesRegistradosNoBancoDeDados = [];

  void registraLeilaoNoBancoDeDados(Leilao leilao) {
    _leiloesRegistradosNoBancoDeDados.add(leilao);
  }

  void removeLeilaoDoBancoDeDados(Leilao leilao) {
    for (int i = 0; i < _leiloesRegistradosNoBancoDeDados.length; i++) {
      if (_leiloesRegistradosNoBancoDeDados[i].codigo == leilao.codigo) {
        _leiloesRegistradosNoBancoDeDados.removeAt(i);
      }
    }
  }

  void atualizaLeilaoNoBancoDeDados(Leilao leilao) {
    for (int i = 0; i < _leiloesRegistradosNoBancoDeDados.length; i++) {
      if (_leiloesRegistradosNoBancoDeDados[i].codigo == leilao.codigo) {
        _leiloesRegistradosNoBancoDeDados[i] = leilao;
      }
    }
  }

  List<Leilao> buscaLeiloesNoBancoDeDados() {
    return _leiloesRegistradosNoBancoDeDados;
  }
}
