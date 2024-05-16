class AuthErrorHandler {
  static String parseError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi tidak benar.';
      case 'account-exists-with-different-credential':
      case 'email-already-in-use':
        return "Email sudah digunakan. Silakan ke halaman login.";
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi ini tidak diizinkan. Silakan aktifkan di Konsol Firebase.';
      case 'invalid-email':
        return 'Alamat email tidak valid.';
      default:
        return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
    }
  }
}
