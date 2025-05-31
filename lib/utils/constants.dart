class Constants {
  static const String ipconfig = '192.168.19.213';
  static const String baseUrl = 'http://$ipconfig:8080'; // Ganti dengan URL Laravel Anda
  static const String apiUrl = '$baseUrl/api';
  
  // Helper untuk URL gambar
  static String imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$baseUrl/storage/$path';
  }
}