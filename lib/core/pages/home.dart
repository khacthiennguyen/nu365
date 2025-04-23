import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/colors.dart';
import 'package:nu365/core/constants/images.dart';
import 'package:nu365/core/states/authenticate/authenticate_bloc.dart';
import 'package:nu365/core/states/authenticate/authenticate_event.dart';
import 'package:nu365/core/states/authenticate/authenticate_state.dart';
import 'package:nu365/core/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  _listenAuthenticateState(BuildContext context) {
    GoRouter goRouter = GoRouter.of(context);

    context.read<AuthenticateBloc>().stream.listen((state) {

      if (state is AuthenticateAuthenticated) {
        goRouter.go("/manage-account");
        return;
      }

      goRouter.go("/sign-in");
      return;
    });
  }

  _loadAuthenticateState(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if(!context.mounted){
      return;
    }

    if(accessToken == null) {

      context.read<AuthenticateBloc>().add(AuthenticateLoggedOut());
      return;
    }

    if (context.mounted) {
      context.read<AuthenticateBloc>().add(AuthenticateLoggedIn(accessToken));
      return;
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
        return Container(
          color: AppColor.darkBlue,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                
                ],
              )),
        );
      },
    );
  }
}
