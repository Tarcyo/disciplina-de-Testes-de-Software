import 'package:flutter_test/flutter_test.dart';
import 'model/lance.dart';
import 'model/participante.dart';
import 'model/leilao.dart';

void main() {
  group("Testes de lances:", () {
    test('verifica se não está aceitando lances em leilões não-abertos', () {
      Leilao leilao = Leilao("01", 'Bolsa', DateTime(2024, 3, 1),
          DateTime(2024, 3, 2), 100, 0, []);

      leilao.defineStatusLeilao(DateTime.now());
      Lance lance =
          Lance(1, 120, Participante('001', 'João', 'aleatorio@gmail.com'));

      final resultado = leilao.recebeLance(lance);

      expect(resultado, 'O leilão não está aberto e não pode receber lances!');
    });

    test('verifica se está aceitando lances em leilões abertos', () {
      DateTime ontem = DateTime.now().subtract(Duration(days: 1));
      DateTime amanha = DateTime.now().add(Duration(days: 1));

      Leilao leilao = Leilao("01", 'Bolsa', ontem, amanha, 100, 0, []);

      leilao.defineStatusLeilao(DateTime.now());
      Lance lance =
          Lance(1, 120, Participante('001', 'João', 'aleatorio@gmail.com'));

      final resultado = leilao.recebeLance(lance);

      expect(resultado, 'Lance aceito!');
    });

    test('verifica se não está aceitando lances menores que o lance mínimo',
        () {
      DateTime ontem = DateTime.now().subtract(Duration(days: 1));

      DateTime amanha = DateTime.now().add(Duration(days: 1));

      Leilao leilao = Leilao("01", 'Carteira', ontem, amanha, 100, 0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lance =
          Lance(1, 90, Participante('001', 'João', 'aleatorio@gmail.com'));

      final resultado = leilao.recebeLance(lance);

      expect(resultado, 'O lance é menor que o lance mínimo!');
    });

    test(
        'Verifica se não está aceitando um lance menor ou igual ao último lance',
        () {
      Leilao leilao = Leilao(
          "01",
          'Cadeira',
          DateTime.now().subtract(Duration(days: 40)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lanceInicial =
          Lance(1, 120.0, Participante('001', 'João', 'aleatorio@gmail.com'));
      leilao.recebeLance(lanceInicial);

      Lance lanceMenor =
          Lance(2, 110.0, Participante('002', 'Maria', 'aleatorio2@gmail.com'));

      String resultado = leilao.recebeLance(lanceMenor);

      expect(resultado, 'O lance deve ser maior ao último lance!');
    });
    test('Verifica se não está aceitando um lance menor ou igual á zero', () {
      Leilao leilao = Leilao(
          "01",
          'Cadeira',
          DateTime.now().subtract(Duration(days: 40)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lance =
          Lance(1, -120.0, Participante('001', 'João', 'aleatorio@gmail.com'));

      expect(() => leilao.recebeLance(lance), throwsArgumentError);
    });

    test('Verifica se está aceitando lance maior que 0', () {
      Leilao leilao = Leilao(
          "01",
          'Cadeira',
          DateTime.now().subtract(Duration(days: 40)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lance =
          Lance(1, 120.0, Participante('001', 'João', 'aleatorio@gmail.com'));

      expect(() => leilao.recebeLance(lance), returnsNormally);
    });

    test(
        'Verifica se não está aceitando que o mesmo usuário faça um lance duas vezes seguidas',
        () {
      Leilao leilao = Leilao(
          "01",
          'Cama',
          DateTime.now().subtract(Duration(days: 1)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      final cliente = Participante('001', 'João', 'aleatorio@gmail.com');

      Lance lanceInicial = Lance(1, 120.0, cliente);
      leilao.recebeLance(lanceInicial);

      Lance lanceRepetido = Lance(2, 130.0, cliente);

      String resultado = leilao.recebeLance(lanceRepetido);

      expect(resultado,
          'O mesmo cliente não pode fazer um lance duas vezes seguidas!');
    });

    test(
        'verifica se está adicionando um lance válido se a lista de lances estiver vazia',
        () {
      Leilao leilao = Leilao(
          "01",
          'Roupa',
          DateTime.now().subtract(Duration(days: 1)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lanceValido =
          Lance(1, 120.0, Participante('001', 'João', 'aleatorio@gmail.com'));

      String resultado = leilao.recebeLance(lanceValido);

      expect(resultado, 'Lance aceito!');
      expect(leilao.lances.length, 1);
      expect(leilao.lances.first, lanceValido);
    });

    test(
        'verifica se está aceitando um lance válido em uma lista que já possui lances',
        () {
      // Arrange
      Leilao leilao = Leilao(
          "01",
          'Mesa',
          DateTime.now().subtract(Duration(days: 1)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lance1 =
          Lance(1, 120.0, Participante('001', 'João', 'aleatorio@gmail.com'));
      Lance lance2 =
          Lance(2, 150.0, Participante('002', 'Maria', 'aleatoria@gmail.com'));
      Lance lance3 =
          Lance(3, 180.0, Participante('003', 'Pedro', 'aleatorio2@gmail.com'));

      final resultado1 = leilao.recebeLance(lance1);
      final resultado2 = leilao.recebeLance(lance2);
      final resultado3 = leilao.recebeLance(lance3);

      expect(resultado1, 'Lance aceito!');
      expect(resultado2, 'Lance aceito!');
      expect(resultado3, 'Lance aceito!');
      expect(leilao.lances.length, equals(3));
      expect(leilao.lances.last.valor, equals(180));
    });

    test('verifica se está retornando o maior lance corretamente.', () {
      // Arrange
      Leilao leilao = Leilao(
          "01",
          'Mesa',
          DateTime.now().subtract(Duration(days: 1)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lance1 =
          Lance(1, 120.0, Participante('001', 'João', 'aleatorio@gmail.com'));
      Lance lance2 =
          Lance(2, 150.0, Participante('002', 'Maria', 'aleatoria@gmail.com'));
      Lance lance3 =
          Lance(3, 180.0, Participante('003', 'Pedro', 'aleatorio2@gmail.com'));

      leilao.recebeLance(lance1);
      leilao.recebeLance(lance2);
      leilao.recebeLance(lance3);

      final resultado = leilao.retornaMaiorLance();

      expect(resultado.codigo, equals(3));
      expect(resultado.valor, equals(180));
      expect(resultado.cliente.nome, equals("Pedro"));
    });

    test('verifica se está retornando o menor lance corretamente.', () {
      // Arrange
      Leilao leilao = Leilao(
          "01",
          'Mesa',
          DateTime.now().subtract(Duration(days: 1)),
          DateTime.now().add(Duration(days: 1)),
          100.0,
          0.0, []);

      leilao.defineStatusLeilao(DateTime.now());

      Lance lance1 =
          Lance(1, 120.0, Participante('001', 'João', 'aleatorio@gmail.com'));
      Lance lance2 =
          Lance(2, 150.0, Participante('002', 'Maria', 'aleatoria@gmail.com'));
      Lance lance3 =
          Lance(3, 180.0, Participante('003', 'Pedro', 'aleatorio2@gmail.com'));

      leilao.recebeLance(lance1);
      leilao.recebeLance(lance2);
      leilao.recebeLance(lance3);

      final resultado = leilao.retornaMenorLance();

      expect(resultado.codigo, equals(1));
      expect(resultado.valor, equals(120));
      expect(resultado.cliente.nome, equals("João"));
    });
  });
}
