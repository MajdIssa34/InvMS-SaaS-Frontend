import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/auth_cubit.dart';
import 'auth/auth_service.dart';
import 'routing/app_router.dart';

// main is now async
void main() async {
  // Required for async calls in main before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Create the AuthService before the app starts
  final authService = await AuthService.create();

  // Pass the service to the app
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider to make the AuthCubit available to the entire app
    return BlocProvider<AuthCubit>(
      // Create the cubit with the service we just passed in
      create: (context) => AuthCubit(authService)..checkAuthentication(),
      child: Builder(
        builder: (context) {
          // Now we can use the router which depends on the cubit
          final appRouter = AppRouter(context.watch<AuthCubit>());

          return MaterialApp.router(
            title: 'Inventory Management System',
            theme: ThemeData.dark(useMaterial3: true),
            // The router config now comes from our AppRouter instance
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}