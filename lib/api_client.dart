import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiClient {
  static final CookieJar cookieJar = CookieJar();
  
  // Define dio without 'final' if you need to re-init, 
  // but keeping it static and adding interceptors is cleaner.
  static final Dio dio = Dio(BaseOptions(
    baseUrl: "https://notes-application-backend-7sca.onrender.com/api", 
    connectTimeout: const Duration(seconds: 5),
    // This allows cookies to be sent cross-origin if needed
    extra: {'withCredentials': true}, 
  ));

  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) return;
    
    dio.interceptors.add(CookieManager(cookieJar));
    
    // DEBUG: This will print every request and response to your console
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      error: true,
    ));
    
    _isInitialized = true;
  }
}