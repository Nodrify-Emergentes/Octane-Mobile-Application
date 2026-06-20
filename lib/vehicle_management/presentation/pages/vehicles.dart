import 'package:octane_mobile/vehicle_management/presentation/pages/vehicle_create_dialog.dart';
import 'package:octane_mobile/vehicle_management/presentation/pages/vehicle_details.dart';
import 'package:octane_mobile/vehicle_management/services/model_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octane_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_state.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:octane_mobile/vehicle_management/services/vehicle_service.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_create_request.dart';
import '../../../notifications/presentation/views/notifications_view.dart';
import '../../../vehicle_wellness/presentation/views/wellness_metrics_view.dart';
import 'package:octane_mobile/l10n/app_localizations.dart';

class Vehicles extends StatelessWidget {
  const Vehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleBloc(
        vehicleService: VehicleService(),
        modelService: ModelService(),
      )..add(FetchAllVehiclesFromOwnerIdEvent(ownerId: 0)),
      child: const VehiclesView(),
    );
  }
}

class VehiclesView extends StatelessWidget {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          localizations.vehicles,
          style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<VehicleBloc>().add(FetchAllVehiclesFromOwnerIdEvent(ownerId: 0));
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            );
          }

          if (state is VehicleError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          if (state is VehiclesLoaded) {
            if (state.vehicles.isEmpty) {
              return Center(child: Text(localizations.noVehiclesFound));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) => _AnimatedVehicleCard(
                index: index,
                child: VehicleCard(vehicle: state.vehicles[index]),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(localizations.addVehicle, style: const TextStyle(fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
    );
  }

  void _openCreateDialog(BuildContext context) async {
    final vehicleBloc = context.read<VehicleBloc>();
    await showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: vehicleBloc,
        child: const VehicleCreateDialog(),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<VehicleBloc>(),
                child: VehicleDetailsPage(vehicleId: vehicle.id),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Image.asset(
                          'assets/images/vehicle.png',
                          fit: BoxFit.contain,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            vehicle.model.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          elevation: 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _navigateToNotifications(context, vehicle.id),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFFFF6B35),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${vehicle.model.brand} ${vehicle.model.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            vehicle.year,
                            style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.credit_card_rounded, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          vehicle.plate,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _navigateToWellnessMetrics(context, vehicle.id),
                          icon: const Icon(Icons.bar_chart_rounded, size: 18),
                          label: Text(localizations.metrics ?? 'Metrics', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              localizations.viewDetails,
                              style: const TextStyle(
                                color: Color(0xFFFF6B35),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Color(0xFFFF6B35),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToWellnessMetrics(BuildContext context, int vehicleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WellnessMetricsScreen(vehicleId: vehicleId),
      ),
    );
  }

  void _navigateToNotifications(BuildContext context, int vehicleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationsView(specificVehicleId: vehicleId),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AnimatedVehicleCard extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedVehicleCard({required this.index, required this.child});

  @override
  State<_AnimatedVehicleCard> createState() => _AnimatedVehicleCardState();
}

class _AnimatedVehicleCardState extends State<_AnimatedVehicleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}