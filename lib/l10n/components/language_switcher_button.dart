import 'package:octane_mobile/l10n/bloc/locale/locale_bloc.dart';
import 'package:octane_mobile/l10n/bloc/locale/locale_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleBloc>().state;
    final isEnglish = currentLocale.languageCode == 'en';

    final newLanguageCode = isEnglish ? 'es' : 'en';
    final buttonLabel = isEnglish ? 'Cambiar a Español' : 'Switch to English';

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<LocaleBloc>().add(
                LocaleChanged(Locale(newLanguageCode)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6B35),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}