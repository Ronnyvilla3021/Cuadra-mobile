import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

class CajaScreen extends StatelessWidget {
  const CajaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Caja', icon: Icons.account_balance_wallet);
  }
}
