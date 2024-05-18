import 'dart:async';
import 'package:flutter/material.dart';

class ShipmentProgressBar extends StatefulWidget {
  final int estimatedDeliveryTimeInMinutes;

  const ShipmentProgressBar(
      {Key? key, required this.estimatedDeliveryTimeInMinutes})
      : super(key: key);

  @override
  _ShipmentProgressBarState createState() => _ShipmentProgressBarState();
}

class _ShipmentProgressBarState extends State<ShipmentProgressBar> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = Duration(minutes: widget.estimatedDeliveryTimeInMinutes);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= oneSecond;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1.0 -
        (_remainingTime.inSeconds /
            (widget.estimatedDeliveryTimeInMinutes * 60));

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        SizedBox(height: 8),
        Text(
          _remainingTime.inSeconds > 0
              ? 'Estimated delivery in ${_formatDuration(_remainingTime)}'
              : 'Delivery in progress',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m ${duration.inSeconds.remainder(60)}s';
  }
}
