import 'package:flutter_test/flutter_test.dart';

import 'package:monai/main.dart';

void main() {
  testWidgets('app starts on the design-system gallery', (tester) async {
    // Arrange
    const app = MyApp();

    // Act
    await tester.pumpWidget(app);
    await tester.pump();

    // Assert
    expect(find.text('Design system'), findsOneWidget);
  });
}
