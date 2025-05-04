import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nu365/app_routes.dart';
import 'package:nu365/features/auth/logic/login_bloc.dart';
import 'package:nu365/features/auth/logic/register_bloc.dart';

import 'core/states/authenticate/authenticate_bloc.dart';

class PlatformMaterial extends StatelessWidget {
  const PlatformMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        navigatorKey: GlobalKey<NavigatorState>(),
        home: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AuthenticateBloc()),
              BlocProvider(create: (context) => LoginBloc()),
              BlocProvider(create: (context) => RegisterBloc()),
            ],
            child: MaterialApp.router(
              routerConfig: appRoutes,
            )),
      ),
    );
  }
}
