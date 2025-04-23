import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/features/sign-in/logic/login_bloc.dart';
import 'package:nu365/features/sign-in/logic/login_event.dart';
import 'package:nu365/features/sign-in/logic/login_state.dart';
import 'package:nu365/features/sign-in/presentation/widgets/auth_tabs.dart';
import 'package:nu365/features/sign-in/presentation/widgets/login_form.dart';
import 'package:nu365/features/sign-in/presentation/widgets/logo_widget.dart';
import 'package:nu365/features/sign-in/presentation/widgets/register_form.dart';
import 'package:nu365/features/sign-in/presentation/widgets/social_login_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
    // Handle registration logic
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
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigate with GoRouter instead of Navigator
          GoRouter.of(context).go('/dashboard');
        } else if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Login failed')),
          );
        } else if (state is LoginToManyRequest) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Too many login attempts. Please try again later.')),
          );
        } else if (state is Login2FARequired) {
          // Handle 2FA navigation here
        }
      },
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
