import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? actions;

  const AppBarWidget({super.key, required this.titulo, this.actions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(titulo, style: Theme.of(context).textTheme.titleLarge),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/home');
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
