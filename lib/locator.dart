import 'package:get_it/get_it.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/blocs/contributionBloc.dart';

import 'package:project_android/services/api.dart';
import 'package:project_android/services/placesService.dart';
import 'package:project_android/services/sharedPref.dart';

GetIt sl = GetIt.instance;

setuplocator() {
  sl.registerLazySingleton(() => Api());
  sl.registerLazySingleton(() => PlacesService());
  sl.registerLazySingleton(() => SharedPreferencesService());
  sl.registerLazySingleton(() => AuthenticationBloc());
  sl.registerFactory(() => ContributionBloc());
}
