import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ReportCard extends StatefulWidget {
  final String title;
  final int count;
  final Color color;

  const ReportCard({
    Key? key,
    required this.title,
    required this.count,
    required this.color,
  }) : super(key: key);

  @override
  _ReportCardState createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  late int _startCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _startCount = 0;
    _animation =
        IntTween(begin: _startCount, end: widget.count).animate(_controller);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ReportCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _startCount = _animation.value;
      _animation =
          IntTween(begin: _startCount, end: widget.count).animate(_controller);
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _animation.value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
