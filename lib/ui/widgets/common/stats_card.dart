import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<FlSpot>? chartData;
  final bool isIncreasing;
  final String? changePercentage;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.chartData,
    this.isIncreasing = true,
    this.changePercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Value
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            // Subtitle with change percentage
            if (changePercentage != null)
              Row(
                children: [
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isIncreasing
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isIncreasing
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: isIncreasing ? Colors.green : Colors.red,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$changePercentage%',
                          style: TextStyle(
                            fontSize: 12,
                            color: isIncreasing ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),

            // Chart
            if (chartData != null && chartData!.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData!,
                          isCurved: true,
                          color: color,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withOpacity(0.2),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(enabled: false),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
