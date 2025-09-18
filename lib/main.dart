import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/dependency_injection.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/pages/main_page.dart';

void main() {
  DependencyInjection.setup();
  runApp(const AhwaBaladyApp());
}

class AhwaBaladyApp extends StatelessWidget {
  const AhwaBaladyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ChangeNotifierProvider.value(
          value: DependencyInjection.orderProvider,
          child: MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            home: const MainPage(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
