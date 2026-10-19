import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/storage/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late SharedAppPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    preferences = SharedAppPreferences(prefs);
  });

  test('onboarding is not completed on a fresh install', () async {
    // Arrange
    // (empty preferences from setUp)

    // Act
    final result = await preferences.isOnboardingCompleted();

    // Assert
    expect(result, isFalse);
  });

  test('onboarding is completed after setting it', () async {
    // Arrange
    // (empty preferences from setUp)

    // Act
    await preferences.setOnboardingCompleted();

    // Assert
    expect(await preferences.isOnboardingCompleted(), isTrue);
  });

  test('reads a flag saved by an earlier launch', () async {
    // Arrange
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final relaunched = SharedAppPreferences(
      await SharedPreferences.getInstance(),
    );

    // Act
    final result = await relaunched.isOnboardingCompleted();

    // Assert
    expect(result, isTrue);
  });
}
