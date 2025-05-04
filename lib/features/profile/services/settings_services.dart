import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/core/data/supabase/supabase_service.dart';
import 'package:nu365/features/profile/logic/settings_state.dart';
import 'package:nu365/features/profile/models/user_info.dart';
import 'package:nu365/setup_service_locator.dart';

class SettingsServices {
  Future<SettingsState> loadUserInfo() async {
    try {
      print("DEBUG: Bắt đầu loadUserInfo");
      final supabase = sl<SupabaseService>().client;
      final sessionData =
          RuntimeMemoryStorage.get<Map<String, dynamic>>('session');

      print("DEBUG: Session data: $sessionData");
      String userId = sessionData!['uId'];
      print("DEBUG: userId: $userId");

      final rl = await supabase.from('users').select().eq('userId', userId);
      print("DEBUG: Supabase response: $rl");

      if (rl.isEmpty) {
        print("DEBUG: Không tìm thấy dữ liệu user");
        return LoadInfoUserFailure(error: "Không tìm thấy dữ liệu người dùng");
      }

      print("DEBUG: Raw data from Supabase: ${rl[0]}");

      try {
        UserInfo userInfo = UserInfo.fromJson(rl[0]);
        print("DEBUG: UserInfo object: $userInfo");

        // Sử dụng phương thức toJsonString mới thay vì toJson()
        print("DEBUG: UserInfo.toJsonString(): ${userInfo.toJsonString()}");

        return LoadInfoUserSuccess(userInfo: userInfo);
      } catch (jsonError) {
        print("DEBUG: Error parsing JSON: $jsonError");

        // Thử tạo UserInfo trực tiếp từ dữ liệu
        try {
          final jsonData = rl[0];

          // Kiểm tra và chuyển đổi các trường ngày tháng
          DateTime createdAt = DateTime.now();
          if (jsonData['created_at'] != null) {
            try {
              createdAt = DateTime.parse(jsonData['created_at']);
            } catch (e) {
              print(
                  "DEBUG: Không thể parse created_at: ${jsonData['created_at']}");
            }
          }

          DateTime? birthDate;
          if (jsonData['dayofbirth'] != null &&
              jsonData['dayofbirth'] != 'NULL') {
            try {
              birthDate = DateTime.parse(jsonData['dayofbirth']);
            } catch (e) {
              print(
                  "DEBUG: Không thể parse dayofbirth: ${jsonData['dayofbirth']}");
            }
          }

          UserInfo userInfo = UserInfo(
            userId: jsonData['userId'] ?? '',
            email: jsonData['email'] ?? '',
            userName: jsonData['userName'] ??
                '', // Thay đổi từ username sang userName
            created_at: createdAt,
            dayofbirth: birthDate,
            goal_calories: jsonData['goal_calories']?.toDouble(),
            goal_protein: jsonData['goal_protein']?.toDouble(),
            goal_fat: jsonData['goal_fat']?.toDouble(),
            goal_carbs: jsonData['goal_carbs']?.toDouble(),
            createdAt: jsonData['created_at'] ?? createdAt.toString(),
          );

          print("DEBUG: Manually created UserInfo: $userInfo");
          print("DEBUG: UserInfo.toJsonString(): ${userInfo.toJsonString()}");

          return LoadInfoUserSuccess(userInfo: userInfo);
        } catch (manualError) {
          print("DEBUG: Error creating UserInfo manually: $manualError");
          return LoadInfoUserFailure(error: "Lỗi xử lý dữ liệu: $manualError");
        }
      }
    } catch (e, stackTrace) {
      print("DEBUG: Error in loadUserInfo: $e");
      print("DEBUG: Stack trace: $stackTrace");
      return LoadInfoUserFailure(error: e.toString());
    }
  }

  Future<SettingsState> updateUserInfo(UserInfo userInfo) async {
    try {
      print("DEBUG: Bắt đầu updateUserInfo");
      final supabase = sl<SupabaseService>().client;

      // Chuẩn bị dữ liệu để cập nhật lên Supabase
      final dataToUpdate = {
        'userName': userInfo.userName,
        'dayofbirth': userInfo.dayofbirth?.toIso8601String(),
        'goal_calories': userInfo.goal_calories,
        'goal_protein': userInfo.goal_protein,
        'goal_fat': userInfo.goal_fat,
        'goal_carbs': userInfo.goal_carbs,
      };

      print("DEBUG: Data to update: $dataToUpdate");

      // Cập nhật dữ liệu lên Supabase
      final response = await supabase
          .from('users')
          .update(dataToUpdate)
          .eq('userId', userInfo.userId);

      print("DEBUG: Update response: $response");

      // Cập nhật thành công, trả về state với thông tin đã cập nhật
      return LoadInfoUserSuccess(userInfo: userInfo);
    } catch (e, stackTrace) {
      print("DEBUG: Error in updateUserInfo: $e");
      print("DEBUG: Stack trace: $stackTrace");
      return LoadInfoUserFailure(error: e.toString());
    }
  }
}
