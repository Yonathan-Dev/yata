import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParatiScreen extends ConsumerStatefulWidget {
  const ParatiScreen({super.key});

  @override
  ConsumerState<ParatiScreen> createState() => _ParatiScreenState();
}

class _ParatiScreenState extends ConsumerState<ParatiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
