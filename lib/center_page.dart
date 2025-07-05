import 'package:flutter/material.dart';

class CenteredPage extends StatelessWidget {
  final Widget child;
  const CenteredPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity,
                padding: const EdgeInsets.all(20),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}