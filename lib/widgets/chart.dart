import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/data/utlity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatelessWidget {
    final int indexx;

    Chart({Key? key, required this.indexx}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        // Determine the data set and the X-axis interval based on the selected time interval
        List<Add_data> data;
        String xAxisLabel;
        switch (indexx) {
            case 0: // Day
                data = today();
                xAxisLabel = 'Hour';
                break;
            case 1: // Week
                data = week();
                xAxisLabel = 'Day';
                break;
            case 2: // Month
                data = month();
                xAxisLabel = 'Day';
                break;
            case 3: // Year
                data = year();
                xAxisLabel = 'Month';
                break;
            default:
                throw Exception('Invalid time interval index');
        }

        // Prepare the data for the chart
        List<SalesData> salesData = prepareSalesData(data, indexx);

        return Container(
            padding: EdgeInsets.all(16),
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: xAxisLabel), // Set the X-axis label
                ),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Amount'), // Set the Y-axis label
                ),
                series: <SplineSeries<SalesData, String>>[
                    SplineSeries<SalesData, String>(
                        color: Color(0xFF603300), // Chart line color
                        width: 3, // Chart line width
                        dataSource: salesData,
                        xValueMapper: (SalesData sales, _) => sales.time, // X-axis data
                        yValueMapper: (SalesData sales, _) => sales.amount, // Y-axis data
                    ),
                ],
            ),
        );
    }

    // Function to prepare sales data for the chart based on the selected time interval
    List<SalesData> prepareSalesData(List<Add_data> data, int indexx) {
        List<SalesData> salesData = [];

        if (indexx == 0) {
            // Hourly data for Day interval
            Map<int, double> hourlyData = {};
            for (var entry in data) {
                int hour = entry.datetime.hour;
                hourlyData.update(hour, (value) => value + entry.entries.total, ifAbsent: () => entry.entries.total);
            }
            hourlyData.forEach((hour, total) => salesData.add(SalesData(hour.toString(), total)));
        } else if (indexx == 1) {
            // Daily data for Week interval
            Map<int, double> dailyData = {};
            for (var entry in data) {
                int day = entry.datetime.day;
                dailyData.update(day, (value) => value + entry.entries.total, ifAbsent: () => entry.entries.total);
            }
            dailyData.forEach((day, total) => salesData.add(SalesData(day.toString(), total)));
        } else if (indexx == 2) {
            // Daily data for Month interval
            Map<int, double> dailyData = {};
            for (var entry in data) {
                int day = entry.datetime.day;
                dailyData.update(day, (value) => value + entry.entries.total, ifAbsent: () => entry.entries.total);
            }
            dailyData.forEach((day, total) => salesData.add(SalesData(day.toString(), total)));
        } else if (indexx == 3) {
            // Monthly data for Year interval
            Map<int, double> monthlyData = {};
            for (var entry in data) {
                int month = entry.datetime.month;
                monthlyData.update(month, (value) => value + entry.entries.total, ifAbsent: () => entry.entries.total);
            }
            monthlyData.forEach((month, total) => salesData.add(SalesData(month.toString(), total)));
        }

        // Return the prepared sales data
        return salesData;
    }
}

// Data structure for sales data used in the chart
class SalesData {
    final String time; // X-axis data (hour, day, or month depending on indexx)
    final double amount; // Y-axis data (amount)

    SalesData(this.time, this.amount);
}
