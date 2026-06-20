import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_create_request.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:octane_mobile/l10n/app_localizations.dart';
import '../bloc/vehicle/vehicle_state.dart';

class VehicleCreateDialog extends StatelessWidget {
  const VehicleCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    context.read<VehicleBloc>().add(LoadVehicleCreateFormEvent());

    final currentYear = DateTime.now().year;
    final years = List.generate(50, (i) => (currentYear - i).toString());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleCreateFormLoading) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
              );
            }

            if (state is VehicleCreateFormError) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(state.message, style: const TextStyle(color: Colors.red)),
              );
            }

            if (state is! VehicleCreateFormLoaded) {
              return const SizedBox.shrink();
            }

            final form = state;
            final brands = form.allModels.map((e) => e.brand).toSet().toList()..sort();
            final plateRegex = RegExp(r'^[0-9]{4}-[A-Z]{2}$');
            final isPlateValid = plateRegex.hasMatch(form.plate);

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFFF6B35)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localizations.addNewVehicle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildInputLabel(localizations.plateFormat),
                  _buildTextField(
                    hint: "e.g. 1234-XY",
                    icon: Icons.tag,
                    onChanged: (value) => context.read<VehicleBloc>().add(UpdateCreatePlateEvent(value.toUpperCase())),
                  ),
                  if (!isPlateValid && form.plate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        localizations.invalidPlateFormat,
                        style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 16),

                  _buildInputLabel(localizations.year),
                  _buildDropdown<String>(
                    hint: localizations.year,
                    value: form.year,
                    items: years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                    onChanged: (val) => context.read<VehicleBloc>().add(UpdateCreateYearEvent(val!)),
                  ),
                  const SizedBox(height: 16),

                  _buildInputLabel(localizations.brand),
                  _buildDropdown<String>(
                    hint: localizations.brand,
                    value: form.selectedBrand,
                    items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (val) => context.read<VehicleBloc>().add(SelectCreateBrandEvent(val!)),
                  ),
                  const SizedBox(height: 16),

                  _buildInputLabel(localizations.model),
                  _buildDropdown<Model>(
                    hint: localizations.model,
                    value: form.filteredModels.contains(form.selectedModel) ? form.selectedModel : null,
                    items: form.filteredModels.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                    onChanged: (m) => context.read<VehicleBloc>().add(SelectCreateModelEvent(m!)),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(localizations.cancel, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (!isPlateValid || form.year == null || form.selectedModel == null)
                              ? null
                              : () {
                            final request = VehicleCreateRequest(
                              plate: form.plate,
                              year: form.year!,
                              modelId: form.selectedModel!.id,
                            );
                            context.read<VehicleBloc>().add(CreateVehicleForOwnerIdEvent(request: request));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(localizations.create, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
          prefixIcon: Icon(icon, color: const Color(0xFFFF6B35), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFFF6B35)),
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}