import 'package:flutter/material.dart';

class CustomProgressBar {
  final BuildContext context;

  CustomProgressBar(this.context);

  static bool progressbarStatus = false;
  static bool hideNormally = true;

  Future<void> showLoadingIndicator() async {
    if (progressbarStatus == false && (ModalRoute.of(context)?.isCurrent ?? false)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: LoadingIndicator(),
            ),
          );
        },
      );
      progressbarStatus = true;
    }
  }

  Future<void> hideLoadingIndicator() async {
    if (progressbarStatus && hideNormally) {
      Navigator.pop(context);
      progressbarStatus = false;
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
