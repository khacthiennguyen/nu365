import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/colors.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/core/states/authenticate/authenticate_bloc.dart';
import 'package:nu365/core/states/authenticate/authenticate_event.dart';
import 'package:nu365/core/states/authenticate/authenticate_state.dart';
import 'package:nu365/features/security/utils/biometric_auth_helper.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  _listenAuthenticateState(BuildContext context) {
    GoRouter goRouter = GoRouter.of(context);

    context.read<AuthenticateBloc>().stream.listen((state) {
      if (state is AuthenticateAuthenticated) {
        goRouter.go("/dashboard");
        return;
      }
      goRouter.go("/sign-in");
      return;
    });
  }

  _loadAuthenticateState(BuildContext context) async {
    try {
      // Check if we already have a session in memory
      if (RuntimeMemoryStorage.hasSession()) {
        var session = RuntimeMemoryStorage
            .getSession()!; // Kiểm tra xem có cần xác thực sinh trắc học không
        final String userId = session['uId'];
        final String accessToken = session['accessToken'];

        // Sử dụng BiometricAuthHelper để xác thực - hỗ trợ tính năng đếm số lần thử
        final authenticated = await BiometricAuthHelper.authenticateOnStartup(
            context, userId, accessToken);

        // Nếu xác thực thất bại, giữ màn hình khởi động
        if (!authenticated) {
          return;
        }

        // Không cần gọi context.read<AuthenticateBloc>().add(AuthenticateLoggedIn(accessToken))
        // vì nó đã được gọi trong authenticateOnStartup nếu xác thực thành công
        return;
      }
      print("DEBUG: No session in memory, checking database");

      // Sử dụng getDatabase() để đảm bảo database đã được khởi tạo
      final db = await SQLite.getDatabase();
      List result = await db.query("Session");
      print(
          "DEBUG: Session query result: ${result.isEmpty ? 'No session found' : 'Session found'}");

      if (!context.mounted) {
        print("DEBUG: Context is no longer mounted after database query");
        return;
      }

      if (result.isEmpty) {
        print("DEBUG: No session found, redirecting to login");
        context.read<AuthenticateBloc>().add(AuthenticateLoggedOut());
        return;
      } // Debug information to help diagnose the issue
      String expiredAtStr = result.first["expiredAt"];
      print("DEBUG: Session expiration string: $expiredAtStr");

      try {
        DateTime expiredAt = DateTime.parse(expiredAtStr);
        print("DEBUG: Parsed expiration: $expiredAt");
        print("DEBUG: Current time: ${DateTime.now()}");
        print("DEBUG: Is expired: ${DateTime.now().isAfter(expiredAt)}");

        if (DateTime.now().isAfter(expiredAt)) {
          print("DEBUG: Session expired, redirecting to login");
          context.read<AuthenticateBloc>().add(AuthenticateLoggedOut());
          await db.delete("Session");
          return;
        }
      } catch (parseError) {
        print("DEBUG: Error parsing expiration date: $parseError");
        // If we can't parse the date, treat the session as valid for now
        // This is to avoid unexpected logouts due to date format issues
      }

      String accessToken = result.first["accessToken"];
      String username = result.first["username"];
      String email = result.first["email"];
      String uId = result.first["uId"];
      print("DEBUG: Loading session data into memory storage");
      RuntimeMemoryStorage.setSession(
          uId: uId,
          username: username,
          email: email,
          accessToken: accessToken,
          expiredAt: expiredAtStr);
      print("DEBUG: Checking biometric authentication requirement");
      // Sử dụng BiometricAuthHelper để xác thực - hỗ trợ tính năng đếm số lần thử
      final authenticated = await BiometricAuthHelper.authenticateOnStartup(
          context, uId, accessToken);

      // Nếu xác thực thất bại, giữ màn hình khởi động
      if (!authenticated) {
        return;
      }

      // Không cần gọi context.read<AuthenticateBloc>().add(AuthenticateLoggedIn(accessToken))
      // vì nó đã được gọi trong authenticateOnStartup nếu xác thực thành công
    } catch (e) {
      print("DEBUG: Error loading authentication state: $e");
      if (context.mounted) {
        context.read<AuthenticateBloc>().add(AuthenticateLoggedOut());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenAuthenticateState(context);
      _loadAuthenticateState(context);
      // BlocProvider.of<AuthenticateBloc>(context).add(AuthenticateLoggedIn("accessToken"));
    });

    return BlocBuilder<AuthenticateBloc, AuthenticateState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/app_logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 30),
                // Hiệu ứng loading bên dưới logo
                CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.darkBlue),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
