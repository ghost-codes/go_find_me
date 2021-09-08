import 'package:get_it/get_it.dart';
import 'package:project_android/blocs/contributionBloc.dart';
import 'package:project_android/blocs/dashboard_bloc.dart';
import 'package:project_android/blocs/editPostBloc.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/services/api.dart';
import 'package:project_android/services/placesService.dart';

GetIt sl = GetIt.instance;

setuplocator() {
  sl.registerLazySingleton(() => Api());
  sl.registerLazySingleton(() => HomeBloc());
  sl.registerLazySingleton(() => DashboardBloc());
  sl.registerLazySingleton(() => PlacesService());
  sl.registerFactory(() => ContributionBloc());
  sl.registerFactory(() => EditPostBloc());
}
