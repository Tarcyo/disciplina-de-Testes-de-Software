import 'leilao.dart';

class ServicoEmail {
  void enviaEmail(Leilao leilao) {
    if (leilao.ganhador != null) {
      print("Email enviado para" + leilao.ganhador!.email);
    }
  }
}
