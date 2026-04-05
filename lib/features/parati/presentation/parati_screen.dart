import '../../../shared/widgets/inactivity_listener.dart';
import '../../../shared/providers/inactivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParaTiScreen extends ConsumerStatefulWidget {
  const ParaTiScreen({super.key});

  @override
  ConsumerState<ParaTiScreen> createState() => _ParaTiScreenState();
}

class _ParaTiScreenState extends ConsumerState<ParaTiScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);
    return InactivityListener(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Pantalla en construcción',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Aquí irá el contenido para ti.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
