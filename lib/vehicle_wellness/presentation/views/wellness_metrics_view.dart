import 'package:octane_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/presentation/widgets/app_drawer.dart';
import '../statemanagement/bloc/wellness_metric_bloc.dart';
import '../widgets/wellness_metric_list.dart';


class WellnessMetricsScreen extends StatelessWidget {
  final int vehicleId;

  const WellnessMetricsScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WellnessMetricBloc>().add(
        LoadWellnessMetricsByVehicleIdEvent(vehicleId),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.metrics} $vehicleId'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: BlocBuilder<WellnessMetricBloc, WellnessMetricState>(
        builder: (context, state) {
          if (state is WellnessMetricsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WellnessMetricsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WellnessMetricBloc>().add(
                        LoadWellnessMetricsByVehicleIdEvent(vehicleId),
                      );
                    },
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          if (state is WellnessMetricsEmpty) {
            return Center(
              child: Text(l10n.noWellnessMetrics),
            );
          }

          if (state is WellnessMetricsLoaded) {
            return WellnessMetricList(metrics: state.metrics);
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.loadingWellnessMetrics),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<WellnessMetricBloc>().add(
                      LoadWellnessMetricsByVehicleIdEvent(vehicleId),
                    );
                  },
                  child: Text(l10n.loadWellnessMetrics),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}