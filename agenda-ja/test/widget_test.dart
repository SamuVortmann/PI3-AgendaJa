import 'package:flutter_test/flutter_test.dart';

import 'package:piteste/main.dart';

void main() {
  testWidgets('exibe as opções iniciais de cadastro e login', (tester) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('Cadastro'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
