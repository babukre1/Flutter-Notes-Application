import 'package:dio/dio.dart';
import 'package:notes_application/services/api_client.dart';

class AuthController {
  // Class-kan wuxuu maamulaa isku xirka Login-ka iyo Signup-ka (Logic-ga)

  Future<void> login(String username, String password) async {
    try {
      // Waxaan u direynaa xogta login-ka endpoint-ka saxda ah
      final response = await ApiClient.dio.post(
        "/auth/login",
        data: {"username": username, "password": password},
      );

      // Haddii response-ka uusan ahayn 200, qalad ayaa dhacay
      if (response.statusCode != 200) {
        throw Exception("Login failed");
      }
    } on DioException catch (e) {
      // Qabo qaladka ka imaanaya server-ka soona bandhig fariinta
      String errorMsg = e.response?.data['msg'] ?? "Authentication failed";
      // soo daabac kusoo bandhig hadii ertor dhaci
      throw Exception(errorMsg);
    }
  }

  Future<void> signup(String username, String fullName, String password) async {
    try {
      // Diiwaangelinta isticmaale cusub iyo dirista macluumaadka
      final response = await ApiClient.dio.post(
        "/auth/signup",
        data: {
          "username": username,
          "fullname": fullName,
          "password": password,
        },
      );

      // Hubi haddii diiwaangelintu guuleysatay (200 ama 201)
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Registration failed");
      }
    } on DioException catch (e) {
      // Haddii uu qalad dhaco xilliga diiwaangelinta
      String errorMsg = "Registration failed";
      if (e.response?.data is Map) {
        errorMsg =
            e.response?.data['msg'] ?? e.response?.data['message'] ?? errorMsg;
      }
      throw Exception(errorMsg);
    }
  }
}
