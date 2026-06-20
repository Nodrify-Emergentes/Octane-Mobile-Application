import 'package:octane_mobile/l10n/app_localizations.dart';
import 'package:octane_mobile/maintenance_and_operations/presentation/pages/maintenance.dart';
import 'package:octane_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:octane_mobile/shared/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:octane_mobile/shared/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:octane_mobile/shared/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:octane_mobile/maintenance_and_operations/services/expense_service.dart';
import 'package:octane_mobile/maintenance_and_operations/services/maintenance_service.dart';
import 'package:octane_mobile/vehicle_management/services/vehicle_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../maintenance_and_operations/presentation/pages/expenses.dart';
import '../../../vehicle_management/presentation/pages/vehicles.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => DashboardBloc(
        vehicleService: VehicleService(),
        maintenanceService: MaintenanceService(),
        expenseService: ExpenseService(),
      )..add(FetchAllDataByOwnerId(ownerId: 0)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.dashboard),
          backgroundColor: const Color(0xFFFF6B35),
          foregroundColor: Colors.white,
        ),
        drawer: const AppDrawer(),
        body: const _DashboardBody(),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (state is DashboardLoaded) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    children: [
                      _SectionTitle(title: "Overview"),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _DashboardStatCard(
                              title: "Vehicles",
                              value: state.vehicles.length.toString(),
                              icon: Icons.directions_car,
                              color: const Color(0xFF380800),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _DashboardStatCard(
                              title: "Expenses",
                              value: state.expenses.length.toString(),
                              icon: Icons.attach_money,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _DashboardStatCard(
                              title: "Maintenances",
                              value: state.maintenances.length.toString(),
                              icon: Icons.build,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      _SectionTitle(title: "Quick Actions"),

                      const SizedBox(height: 16),

                      _QuickActionButton(
                        icon: Icons.directions_car,
                        label: "View Vehicles",
                        onTap: () => navigateTo(context, const Vehicles()),
                      ),

                      const SizedBox(height: 12),

                      _QuickActionButton(
                        icon: Icons.attach_money,
                        label: "View Expenses",
                        onTap: () => navigateTo(context, const Expenses()),
                      ),

                      const SizedBox(height: 12),

                      _QuickActionButton(
                        icon: Icons.build,
                        label: "View Maintenances",
                        onTap: () => navigateTo(context, const Maintenance()),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text(
            "Pull to refresh or try again later",
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF380800),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF380800)),
          onPressed: () {
            context
                .read<DashboardBloc>()
                .add(FetchAllDataByOwnerId(ownerId: 0));
          },
        ),
      ],
    );
  }

  void navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF380800),
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.orange.shade700),
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF380800),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right,
                  size: 26, color: Colors.orange.shade700)
            ],
          ),
        ),
      ),
    );
  }
}
