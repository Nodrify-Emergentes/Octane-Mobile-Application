import 'package:octane_mobile/iam/bloc/authentication/authentication_bloc.dart';
import 'package:octane_mobile/iam/presentation/views/sign-in.page.dart';
import 'package:octane_mobile/iam/services/authentication_service.dart';
import 'package:octane_mobile/iam/services/profile_service.dart';
import 'package:octane_mobile/l10n/app_localizations.dart';
import 'package:octane_mobile/notifications/bloc/notifications_bloc.dart';
import 'package:octane_mobile/notifications/services/notifications_websocket_service.dart';
import 'package:octane_mobile/vehicle_wellness/data/datasource/wellness_metric_datasource.dart';
import 'package:octane_mobile/vehicle_wellness/data/repository/wellness_metric_repository_impl.dart';
import 'package:octane_mobile/vehicle_wellness/domain/usecases/CreateWellnessMetricUseCase.dart';
import 'package:octane_mobile/vehicle_wellness/domain/usecases/DeleteWellnessMetricUseCase.dart';
import 'package:octane_mobile/vehicle_wellness/domain/usecases/GetWellnessMetricByIdUseCase.dart';
import 'package:octane_mobile/vehicle_wellness/domain/usecases/GetWellnessMetricsByVehicleIdUseCase.dart';
import 'package:octane_mobile/vehicle_wellness/domain/usecases/UpdateWellnessMetricUseCase.dart';
import 'package:octane_mobile/vehicle_wellness/presentation/statemanagement/bloc/wellness_metric_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'l10n/bloc/locale/locale_bloc.dart';
import 'notifications/services/notifications_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final dataSource = WellnessMetricDataSource();


    final repository = WellnessMetricRepositoryImpl(dataSource: dataSource);


    final createUseCase = CreateWellnessMetricUseCase(repository);
    final updateUseCase = UpdateWellnessMetricUseCase(repository);
    final deleteUseCase = DeleteWellnessMetricUseCase(repository);
    final getByIdUseCase = GetWellnessMetricByIdUseCase(repository);
    final getByVehicleIdUseCase = GetWellnessMetricsByVehicleIdUseCase(repository);

    final notificationService = NotificationService();
    final webSocketService = NotificationWebSocketService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => LocaleBloc()
        ),
        BlocProvider(
          create: (_) => AuthenticationBloc(
            authenticationService: AuthenticationService(),
            profileService: ProfileService()
          )
        ),
        BlocProvider(
          create: (_) => WellnessMetricBloc(
            createWellnessMetric: createUseCase,
            updateWellnessMetric: updateUseCase,
            deleteWellnessMetric: deleteUseCase,
            getWellnessMetricById: getByIdUseCase,
            getWellnessMetricsByVehicleId: getByVehicleIdUseCase,
          ),
        ),
        BlocProvider(
          create: (_)=> NotificationsBloc(notificationService: notificationService, webSocketService: webSocketService),
        )
      ],
      child: BlocBuilder<LocaleBloc,Locale>(
        builder: (context, localeState) {
          return MaterialApp(
            title: 'Octane',
            locale: localeState,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
              home: SignInPage(),
          );
        }
      )
    );
  }
}
