import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceChart extends StatelessWidget {
  final List<PerformanceData> data;
  final String title;
  final String subtitle;
  final bool showLegend;
  final ChartType chartType;

  const PerformanceChart({
    Key? key,
    required this.data,
    required this.title,
    required this.subtitle,
    this.showLegend = true,
    this.chartType = ChartType.bar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 300,
              child:
                  chartType == ChartType.bar
                      ? _buildBarChart(context)
                      : chartType == ChartType.line
                      ? _buildLineChart(context)
                      : _buildPieChart(context),
            ),

            // Legend
            if (showLegend)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: data.map((item) => _buildLegendItem(item)).toList(),
                ),
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
                '${data[groupIndex].label}: ${rod.toY.round()}',
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
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()].label,
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
            data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: item.value,
                    color: item.color,
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= 0 && index < data.length) {
                  return LineTooltipItem(
                    '${data[index].label}: ${spot.y.round()}',
                    TextStyle(color: Colors.white),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()].label,
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
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots:
                data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.value);
                }).toList(),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections:
            data.map((item) {
              return PieChartSectionData(
                color: item.color,
                value: item.value,
                title: '${item.value.round()}%',
                radius: 100,
                titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildLegendItem(PerformanceData item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          item.label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

class PerformanceData {
  final String label;
  final double value;
  final Color color;

  PerformanceData({
    required this.label,
    required this.value,
    required this.color,
  });
}

enum ChartType { bar, line, pie }
