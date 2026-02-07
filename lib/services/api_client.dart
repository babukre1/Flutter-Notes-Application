import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:cookie_jar/cookie_jar.dart';

class ApiClient {
  static final CookieJar cookieJar = CookieJar();

  // Define dio without 'final' if you need to re-init,
  // but keeping it static and adding interceptors is cleaner.

  // dio waxa lo isticmalaa si loo fududeeyo api calls mana u baahno configuration badan
  static final Dio dio = Dio(
    BaseOptions(
      // kan waa url ka backend gena
      baseUrl: "https://notes-application-backend-7sca.onrender.com/api",
      connectTimeout: const Duration(seconds: 5),
      // cookies ayu u samaxaa inee diraan cross-origin if needed
      extra: {'withCredentials': true},
    ),
  );

  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) return;

    dio.interceptors.add(CookieManager(cookieJar));
    _isInitialized = true;
  }
}
