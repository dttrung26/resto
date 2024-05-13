import 'package:resto/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum userAttributes {
  userName,
  email,
  phoneNumber,
  role,
  address,
  postCode,
  cardNumber,
  balance,
}

class LocalService {
  static saveUserToLocalService(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userAttributes.userName as String, user.username);
    await prefs.setString(userAttributes.email as String, user.email);
    await prefs.setString(
        userAttributes.phoneNumber as String, user.phoneNumber ?? "");
    await prefs.setString(userAttributes.role as String, user.role);
    await prefs.setString(userAttributes.address as String, user.address ?? "");
    await prefs.setString(
        userAttributes.postCode as String, user.postcode ?? "");
    await prefs.setString(
        userAttributes.cardNumber as String, user.cardNumber ?? "");
    await prefs.setDouble(userAttributes.balance as String, user.balance);
  }
}
