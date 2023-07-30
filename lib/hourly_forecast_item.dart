import 'dart:ui';

import 'package:flutter/material.dart';

class HourlyForecaseItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForecaseItem(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Icon(
                    icon,
                    size: 35,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    temperature,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
