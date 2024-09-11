import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final bool canPop;
  const LoadingDialog({
    super.key,
    required this.canPop
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        
      },
      child: const Dialog(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}