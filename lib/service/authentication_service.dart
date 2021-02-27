import 'package:despesa_app/model/user.dart';
import 'package:despesa_app/service/base_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthenticationService {

  static String token;
  static int expiresIn;
  static User currentUser;

  AuthenticationService._privateConstructor();
  static final AuthenticationService instance = AuthenticationService._privateConstructor();

  static final _baseService = BaseService("/auth");

  Future<bool> signUp(String fullName, String username, String password, String confirmPassword) async {
    dynamic response = await _baseService.post(
      "/signup",
      <String, String> {
        "full_name": fullName,
        "username": username,
        "password": password,
        "confirm_password": confirmPassword
      }
    );
    return true;
  }

  Future<bool> login(String username, String password) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    final response = await _baseService.post(
      "/token",
      <String, dynamic> {
        "username": username,
        "password": password,
        "device": <String, String> {
          "token": await _firebaseMessaging.getToken()
        }
      }
    );

    token = response["token"];
    expiresIn = response["expires_in"];
    currentUser = await _me();

    return true;
  }

  void logout() {
    token = null;
    expiresIn = null;
    currentUser = null;
  }

  Future<User> _me() async {
    dynamic response = await _baseService.get(
      "/me"
    );
    return User.fromJson(response);
  }
}