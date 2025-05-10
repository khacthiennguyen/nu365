import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/features/auth/logic/login_bloc.dart';
import 'package:nu365/features/auth/logic/login_event.dart';
import 'package:nu365/features/auth/logic/login_state.dart';
import 'package:nu365/features/auth/logic/register_bloc.dart';
import 'package:nu365/features/auth/logic/register_event.dart';
import 'package:nu365/features/auth/logic/register_state.dart';
import 'package:nu365/features/auth/presentation/pages/otp_screen.dart';
import 'package:nu365/features/auth/presentation/widgets/auth_tabs.dart';
import 'package:nu365/features/auth/presentation/widgets/login_form.dart';
import 'package:nu365/features/auth/presentation/widgets/logo_widget.dart';
import 'package:nu365/features/auth/presentation/widgets/register_form.dart';
import 'package:nu365/features/auth/presentation/widgets/social_login_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    context.read<LoginBloc>().add(
          LoginSubmittedEvent(
            username: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  void _handleRegister() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterSubmittedEvent(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
  }

  void _handleForgotPassword() {
    // Handle forgot password
  }

  void _handleGoogleLogin() {
    // Handle Google login
  }

  void _handleFacebookLogin() {
    // Handle Facebook login
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            // Xử lý các trạng thái ban đầu hoặc loading
            if (state is LoginLoading) {
              // Hiển thị loading indicator
              return;
            }

            if (state is LoginInitial) {
              // Không cần xử lý ở trạng thái khởi tạo
              return;
            }

            // Xử lý trường hợp đăng nhập thành công
            if (state is LoginSuccess) {
              GoRouter.of(context).go('/dashboard');
              return;
            }

            // Xử lý trường hợp yêu cầu xác thực 2FA
            if (state is Login2FARequired) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OtpScreen(
                    email: state.email,
                    password: state.password,
                  ),
                ),
              );
              return;
            }

            // Xử lý các trường hợp lỗi
            if (state is LoginToManyRequest) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Too many login attempts. Please try again later.')),
              );
              return;
            }

            if (state is LoginFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Login failed')),
              );
              return;
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            // Xử lý trạng thái ban đầu hoặc loading
            if (state is RegisterLoading || state is RegisterInitial) {
              return;
            }

            // Xử lý trường hợp đăng ký thành công
            if (state is RegisterSuccess) {
              // Hiển thị thông báo thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Registration successful! Please login to continued.'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(12),
                ),
              );

              // Xóa thông tin từ các trường nhập liệu
              _nameController.clear();
              _emailController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();

              // Chuyển về tab đăng nhập
              _tabController.animateTo(0);
              return;
            }

            // Xử lý trường hợp tài khoản cần kích hoạt
            if (state is RegisterActivationRequired) {
              // Hiển thị thông báo cần xác thực email
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Please check your email to activate your account')),
              );

              // Chuyển về tab đăng nhập
              _tabController.animateTo(0);
              return;
            }

            // Xử lý trường hợp quá nhiều yêu cầu
            if (state is RegisterToManyRequest) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Too many registration attempts. Please try again later.')),
              );
              return;
            }

            // Xử lý trường hợp đăng ký thất bại
            if (state is RegisterFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Registration failed')),
              );
              return;
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthLogo(),
                    const SizedBox(height: 32),
                    AuthTabs(tabController: _tabController),
                    const SizedBox(height: 24),
                    _buildAuthForms(),
                    const SizedBox(height: 24),
                    SocialLoginSection(
                      onGooglePressed: _handleGoogleLogin,
                      onFacebookPressed: _handleFacebookLogin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthForms() {
    return SizedBox(
      height: 350,
      child: TabBarView(
        controller: _tabController,
        children: [
          LoginForm(
            emailController: _emailController,
            passwordController: _passwordController,
            onLoginPressed: _handleLogin,
            onForgotPasswordPressed: _handleForgotPassword,
          ),
          RegisterForm(
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            onRegisterPressed: _handleRegister,
          ),
        ],
      ),
    );
  }
}
