class ApiConfig {
  // 🌍 Base URLs for different environments
  // static const String devBaseUrl = "http://localhost:5000/";
  // 127.0.0.1
  static const String devBaseUrl = "http://192.168.1.177:5000/";//home
  // static const String devBaseUrl = "http://192.168.0.115:5000/";//office

 
  static const String prodBaseUrl = "https://yourdomain.com/api";

  // 🔹 Change this to switch environments
  static const String baseUrl = devBaseUrl;
}