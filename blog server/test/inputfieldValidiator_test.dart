import 'package:flutter_test/flutter_test.dart';

void main() {
  group("InputValidation", () {
    test("Testing for valid email from the input field", () {
      var result = "rnb@gmail.com".isValidEmail();
      expect(result, true);

      var result2 = "nnnnn@.com".isValidEmail();
      expect(result2, false);
    });

    test("Testing for valid Username for Login or Register", () {
      var result = "tgnduisnew_a".isValidName();
      expect(result, true);

      var result2 = "ppwwsisn.ew@".isValidName();
      expect(result2, false);
    });

    test("Testing for valid Password for Login or Register", () {
      var result = "6731".isValidName();
      expect(result, true);

      var result2 = "hahais_-n.ew@".isValidName();
      expect(result2, false);
    });
  });
}
