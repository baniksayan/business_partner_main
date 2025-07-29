// import 'package:get_it/get_it.dart';
// import 'package:dio/dio.dart';
// // Import all your dependencies

// final sl = GetIt.instance;

// Future<void> init() async {
//   // External
//   sl.registerLazySingleton(() => Dio());
  
//   // Core
//   sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
  
//   // Repositories
//   sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  
//   // ViewModels
//   sl.registerFactory(() => SplashViewModel(sl()));
//   sl.registerFactory(() => LoginViewModel(sl()));
  
//   // Services
//   sl.registerLazySingleton(() => NavigationService());
// }
