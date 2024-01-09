import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final int daysInMonth = 30;
  final List<int> markedDays = [2, 8, 9, 10, 11, 15];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'September',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: daysInMonth,
          itemBuilder: (context, index) {
            final dayNumber = index + 1;
            final isMarked = markedDays.contains(dayNumber);
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isMarked ? Colors.orange[100] : null,
                borderRadius: isMarked ? BorderRadius.circular(8.0) : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: isMarked && dayNumber == 15
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isMarked && dayNumber == 15)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Text(
                          dayNumber.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
