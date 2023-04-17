import 'package:authentication/authentication_status.dart';
import 'package:authentication/bloc/authentication_bloc.dart';
import 'package:authentication/bloc/authentication_state.dart';
import 'package:bkav_hrm_app/login_page.dart';
import 'package:bkav_hrm_app/respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:utils/navigation_service.dart';

import 'home_page.dart';
import 'loading_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const AppMain());
}

class AppMain extends StatefulWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  // late Repository repository;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // repository = ConfigBuild.isFakeUserRepo
    //     ? FakeDataSource()
    //     : RepositoryImpl(context: context);
    // // Tạm thời tắt chế độ xoay ngang màn hình
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return /*RepositoryProvider.value(
      value: repository,
      child:*/
        MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc(Repository()),
        ),
        // BlocProvider(create: (_) => SalesSlipBloc(repository: repository)),
        // BlocProvider(create: (_) => SalesSlipBloc(repository: repository)),
        // BlocProvider(create: (_) => PaymentMoneyBLoc(repository: repository)),
        // BlocProvider(create: (_) => PaymentBillBLoc(repository: repository)),
        // BlocProvider(create: (_) => PaySlipReturnBLoc(repository: repository))
      ],
      child: _AIBookView(),
    ) /*)*/;
  }
}

class _AIBookView extends StatefulWidget {
  @override
  State<_AIBookView> createState() => _AIBookState();
}

class _AIBookState extends State<_AIBookView> {
  final _navigatorKey = NavigationService.navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    // context.read<Repository>().updateTokenFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        /*   localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],*/
        // theme: ThemeData(
        //     primaryColor: AppColor.main,
        //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //         backgroundColor: AppColor.main)),
        // supportedLocales: S.delegate.supportedLocales,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const HomePage()),
                        (route) => false);
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LoginPage()),
                        (route) => false);
                    break;
                  default:
                    break;
                }
              },
              child: child);
        },
        onGenerateRoute: (_) => LoadingPage.route());
  }
}
