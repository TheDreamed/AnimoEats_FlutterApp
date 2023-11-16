import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animo_eats/bloc/chat/chat_bloc.dart';
import 'package:animo_eats/bloc/food/food_bloc.dart';
import 'package:animo_eats/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:animo_eats/bloc/login/login_bloc.dart';
import 'package:animo_eats/bloc/order/order_bloc.dart';
import 'package:animo_eats/bloc/profile/profile_bloc.dart';
import 'package:animo_eats/bloc/register/register_bloc.dart';
import 'package:animo_eats/bloc/settings/settings_bloc.dart';
import 'package:animo_eats/bloc/testimonial/testimonial_bloc.dart';
import 'package:animo_eats/bloc/theme/theme_bloc.dart';
import 'package:animo_eats/repositories/order_repository.dart';
import 'package:animo_eats/services/hive_adapters.dart';
import 'package:animo_eats/utils/app_router.dart';
import 'package:animo_eats/utils/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animo_eats/bloc/restaurant/restaurant_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(FirestoreDocumentReferenceAdapter());
  Hive.registerAdapter(RestaurantAdapter());
  Hive.registerAdapter(FoodAdapter());
  await Hive.openBox('myBox');

  OrderRepository.loadCart();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordBloc(),
        ),
        BlocProvider(
          create: (context) => RestaurantBloc(),
        ),
        BlocProvider(
          create: (context) => FoodBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => TestimonialBloc(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        ThemeData themeData =
            Hive.box('myBox').get('isDarkMode', defaultValue: false)
                ? AppTheme().darkThemeData
                : AppTheme().lightThemeData;
        if (state is ThemeChanged) {
          themeData = state.themeData;
        }

        return MaterialApp(
          title: "Animo Eats",
          theme: themeData,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
