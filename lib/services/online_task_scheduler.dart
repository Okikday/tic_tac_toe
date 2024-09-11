import 'dart:async';

import 'package:flutter/material.dart';

class OnlineTaskScheduler {
  Timer? _timer;


  // Starts the online task and stores the Timer instance
  void runOnlineTask(BuildContext context, void Function() taskToRun, {int seconds = 4}) {
    _timer = Timer.periodic(Duration(seconds: seconds), (Timer timer) {
      if(context.mounted){
        taskToRun();
      }else{
        timer.cancel();
      }
    });
  }

  // Ends the online task if it's running
  void endOnlineTask() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null; // Clear the timer
    }
  }
}
