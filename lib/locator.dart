import 'package:get_it/get_it.dart';
import 'package:project_android/blocs/dashboard_bloc.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/services/api.dart';

GetIt sl = GetIt.instance;

setuplocator() {
  sl.registerLazySingleton(() => Api());
  sl.registerLazySingleton(() => HomeBloc());
  sl.registerLazySingleton(() => DashboardBloc());
}
