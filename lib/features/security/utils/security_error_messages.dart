// Helper class for error messages
class SecurityErrorMessages {
  // Lỗi chung
  static const String defaultError = "Đã xảy ra lỗi, vui lòng thử lại sau";
  static const String networkError =
      "Lỗi kết nối mạng, vui lòng kiểm tra kết nối internet";
  static const String serverError =
      "Đã xảy ra lỗi hệ thống, vui lòng thử lại sau";
  static const String invalidCredentials = "Thông tin xác thực không đúng";

  // Lỗi mật khẩu
  static const String invalidPassword = "Mật khẩu không chính xác";
  static const String emptyPassword = "Vui lòng nhập mật khẩu";

  // Lỗi OTP
  static const String invalidOTP = "Mã OTP không chính xác";
  static const String invalidOTPFormat = "Mã OTP phải gồm 6 chữ số";

  // Lỗi 2FA
  static const String twoFANotEnabled =
      "Tài khoản của bạn chưa bật xác thực 2 lớp";
  static const String twoFASetupExpired =
      "Phiên thiết lập xác thực 2 lớp đã hết hạn, vui lòng thử lại";
  static const String enableTwoFAFailed =
      "Không thể bật xác thực 2 lớp, vui lòng thử lại sau";
  static const String disableTwoFAFailed =
      "Không thể tắt xác thực 2 lớp, vui lòng thử lại sau";

  // Lấy thông báo lỗi dựa trên mã lỗi API
  static String getMessageForErrorCode(int code, bool is2FAEnabled) {
    switch (code) {
      // Disable 2FA error codes
      case 4016: // 2FA is not enabled
        return twoFANotEnabled;
      case 4017: // Invalid OTP code (disable)
        return invalidOTP;
      case 5014: // Failed to disable 2FA
        return disableTwoFAFailed;

      // Enable 2FA error codes
      case 4013: // 2FA setup expired
        return twoFASetupExpired;
      case 4014: // Invalid OTP code (enable)
        return invalidOTP;
      case 5012: // Failed to enable 2FA
        return enableTwoFAFailed;

      default:
        return is2FAEnabled
            ? "Lỗi khi tắt xác thực 2 lớp: Mã lỗi $code"
            : "Lỗi khi bật xác thực 2 lớp: Mã lỗi $code";
    }
  }
}
