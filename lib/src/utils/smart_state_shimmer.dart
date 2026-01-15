import 'package:flutter/material.dart';

/// Simple shimmer effect for skeleton loading without external dependencies
class SmartStateShimmer extends StatefulWidget {
  const SmartStateShimmer({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 4.0,
    this.duration = const Duration(milliseconds: 1500),
  });

  final double? width;
  final double height;
  final double borderRadius;
  final Duration duration;

  @override
  State<SmartStateShimmer> createState() => _SmartStateShimmerState();
}

class _SmartStateShimmerState extends State<SmartStateShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 - _controller.value * 2, 0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton loading widgets
class SmartStateSkeleton {
  /// Creates a list of skeleton items
  static Widget list({
    int itemCount = 5,
    double itemHeight = 80.0,
    double spacing = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
  }) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SmartStateShimmer(width: 40, height: 40, borderRadius: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmartStateShimmer(width: double.infinity, height: 16),
                        SizedBox(height: 8),
                        SmartStateShimmer(width: 120, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SmartStateShimmer(width: double.infinity, height: 12),
              SizedBox(height: 4),
              SmartStateShimmer(width: 200, height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Creates a grid of skeleton items
  static Widget grid({
    int itemCount = 6,
    double itemHeight = 120.0,
    int crossAxisCount = 2,
    double spacing = 8.0,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmartStateShimmer(
                  width: double.infinity, height: 60, borderRadius: 8),
              SizedBox(height: 12),
              SmartStateShimmer(width: double.infinity, height: 16),
              SizedBox(height: 8),
              SmartStateShimmer(width: 80, height: 12),
            ],
          ),
        );
      },
    );
  }
}
