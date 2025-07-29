class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add all your ViewModels here
        ChangeNotifierProvider(create: (_) => di.sl<SplashViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<LoginViewModel>()),
        // ... other providers
      ],
      child: MaterialApp(
        title: 'Business Partner Dashboard',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: SplashScreen(),
        navigatorKey: di.sl<NavigationService>().navigatorKey,
      ),
    );
  }
}
