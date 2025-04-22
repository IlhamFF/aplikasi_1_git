import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GradeChart extends StatelessWidget {
  final List<SubjectGrade> grades;
  final String title;
  final String subtitle;
  final ChartType chartType;

  const GradeChart({
    Key? key,
    required this.grades,
    required this.title,
    required this.subtitle,
    this.chartType = ChartType.bar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate average grade
    final totalGrade = grades.fold(0.0, (sum, grade) => sum + grade.value);
    final averageGrade = grades.isNotEmpty ? totalGrade / grades.length : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with average grade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getGradeColor(averageGrade).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Rata-rata',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        averageGrade.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getGradeColor(averageGrade),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 300,
              child:
                  chartType == ChartType.bar
                      ? _buildBarChart(context)
                      : _buildRadarChart(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${grades[groupIndex].subject}: ${rod.toY.round()}',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < grades.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      grades[value.toInt()].subject,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
          },
        ),
        barGroups:
            grades.asMap().entries.map((entry) {
              final index = entry.key;
              final grade = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: grade.value,
                    color: _getGradeColor(grade.value),
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildRadarChart(BuildContext context) {
    return RadarChart(
      RadarChartData(
        radarTouchData: RadarTouchData(
          enabled: true,
          touchTooltipData: RadarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.dataSetIndex;
                if (index >= 0 && index < grades.length) {
                  return RadarTooltipItem(
                    '${grades[index].subject}: ${spot.value.round()}',
                    TextStyle(color: Colors.white),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
        dataSets: [
          RadarDataSet(
            dataEntries:
                grades.map((grade) => RadarEntry(value: grade.value)).toList(),
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.2),
            borderColor: Theme.of(context).primaryColor,
            borderWidth: 2,
          ),
        ],
        tickCount: 5,
        ticksTextStyle: TextStyle(color: Colors.grey.shade600, fontSize: 10),
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        getTitle: (index) {
          if (index >= 0 && index < grades.length) {
            return grades[index].subject;
          }
          return '';
        },
      ),
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 80) return Colors.green;
    if (grade >= 70) return Colors.blue;
    if (grade >= 60) return Colors.orange;
    return Colors.red;
  }
}

class SubjectGrade {
  final String subject;
  final double value;

  SubjectGrade({required this.subject, required this.value});
}

enum ChartType { bar, radar }
