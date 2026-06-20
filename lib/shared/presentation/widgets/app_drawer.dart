import 'package:octane_mobile/iam/presentation/views/sign-in.page.dart';
import 'package:octane_mobile/l10n/app_localizations.dart';
import 'package:octane_mobile/l10n/components/language_switcher_button.dart';
import 'package:octane_mobile/maintenance_and_operations/presentation/views/expenses.dart';
import 'package:octane_mobile/maintenance_and_operations/presentation/views/maintenance.dart';
import 'package:octane_mobile/shared/presentation/views/dashboard.dart';
import 'package:octane_mobile/vehicle_management/presentation/views/vehicles.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35),
            ),
            child: Text(
              'Octane',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(localizations.dashboard),
            onTap: () => navigateTo(context, const Dashboard()),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: Text(localizations.maintenance),
            onTap: () => navigateTo(context, const Maintenance()),
          ),
          ListTile(
            leading: const Icon(Icons.monitor),
            title: Text(localizations.monitoring),
            onTap: () => navigateTo(context, const Vehicles()),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: Text(localizations.expenses),
            onTap: () => navigateTo(context, const Expenses()),
          ),
          ListTile(
            leading: const Icon(Icons.two_wheeler),
            title: Text(localizations.vehicles),
            onTap: () => navigateTo(context, const Vehicles()),
          ),
          const Divider(
            thickness: 2,
          ),
          LanguageSwitcherButton(),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(localizations.logout, style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
              );

            },
          )
        ],
      ),
    );
  }
}
