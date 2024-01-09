// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fleety/core/network/graphql_client.dart' as _i3;
import 'package:fleety/core/repository/ilocal_repository.dart' as _i5;
import 'package:fleety/core/repository/iremote_repository.dart' as _i7;
import 'package:fleety/core/repository/local_repository.dart' as _i6;
import 'package:fleety/core/repository/remote_repository.dart' as _i8;
import 'package:fleety/dependency_injection/module/shared_preference_module.dart'
    as _i17;
import 'package:fleety/modules/authentication/data/network/authentication_api.dart'
    as _i9;
import 'package:fleety/modules/authentication/data/repository/authentication_repository.dart'
    as _i12;
import 'package:fleety/modules/authentication/data/repository/iauthentication_repository.dart'
    as _i11;
import 'package:fleety/modules/authentication/presentation/bloc/authentication_bloc.dart'
    as _i15;
import 'package:fleety/modules/home/data/network/home_api.dart' as _i10;
import 'package:fleety/modules/home/data/respository/home_repository.dart'
    as _i14;
import 'package:fleety/modules/home/data/respository/ihome_repository.dart'
    as _i13;
import 'package:fleety/modules/home/presentation/bloc/home_bloc.dart' as _i16;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final preferenceModule = _$PreferenceModule();
    gh.factory<_i3.BaseGraphQLClient>(() => _i3.BaseGraphQLClient());
    await gh.factoryAsync<_i4.SharedPreferences>(
      () => preferenceModule.prefs,
      preResolve: true,
    );
    gh.factory<_i5.ILocalRepository>(
        () => _i6.LocalRepository(gh<_i4.SharedPreferences>()));
    gh.factory<_i7.IRemoteRepository>(() => _i8.RemoteRepository(
          gh<_i3.BaseGraphQLClient>(),
          gh<_i5.ILocalRepository>(),
        ));
    gh.factory<_i9.AuthenticationAPI>(
        () => _i9.AuthenticationAPI(gh<_i7.IRemoteRepository>()));
    gh.factory<_i10.HomeAPI>(() => _i10.HomeAPI(gh<_i7.IRemoteRepository>()));
    gh.factory<_i11.IAuthenticationRepository>(
        () => _i12.AuthenticationRepository(gh<_i9.AuthenticationAPI>()));
    gh.factory<_i13.IHomeRepository>(
        () => _i14.HomeRepository(gh<_i10.HomeAPI>()));
    gh.factory<_i15.AuthenticationBloc>(() => _i15.AuthenticationBloc(
          gh<_i11.IAuthenticationRepository>(),
          gh<_i5.ILocalRepository>(),
        ));
    gh.factory<_i16.HomeBloc>(() => _i16.HomeBloc(gh<_i13.IHomeRepository>()));
    return this;
  }
}

class _$PreferenceModule extends _i17.PreferenceModule {}
