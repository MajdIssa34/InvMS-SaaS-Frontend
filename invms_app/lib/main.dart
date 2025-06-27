import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invms_app/models/api_key_repository.dart';
import 'api/api_client.dart';
import 'auth/auth_cubit.dart';
import 'auth/auth_service.dart';
import 'routing/app_router.dart';
import 'features/developer_portal/blocs/api_key_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = await AuthService.create();
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    // Use MultiRepositoryProvider to provide instances of our API clients/repos
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider(create: (context) => ApiClient(authService)),
        RepositoryProvider(
          create: (context) => ApiKeyRepository(context.read<ApiClient>()),
        ),
      ],
      // MultiBlocProvider to provide our cubits
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authService)..checkAuthentication(),
          ),
          BlocProvider(
            create: (context) => ApiKeyCubit(context.read<ApiKeyRepository>()),
          ),
        ],
        child: Builder(
          builder: (context) {
            final appRouter = AppRouter(context.watch<AuthCubit>());
            return MaterialApp.router(
              title: 'Inventory Management System',
              theme: ThemeData.dark(useMaterial3: true),
              routerConfig: appRouter.router,
            );
          },
        ),
      ),
    );
  }
}