import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ItemDetailsPage extends StatelessWidget {
  final Add_data item;
  final Box<Add_data> box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter entries with the same unit name as the provided item
    List<Add_data> entriesWithSameUnitName = box.values
        .where((entry) => entry.entries.unitName == item.entries.unitName)
        .toList();

    // Prepare data for chart
    final List<String> xValues = [];
    final List<double> yValues = [];

    // Process each entry as a separate point
    for (int i = 0; i < entriesWithSameUnitName.length; i++) {
      final entry = entriesWithSameUnitName[i];
      
      // Generate a unique x-axis value with date and index
      // This will separate entries on the same date
      final dateString = '${entry.datetime.year}-${entry.datetime.month}-${entry.datetime.day}';
      xValues.add('$dateString - Entry $i');
      
      // Add unit price as y value
      yValues.add(entry.entries.unitPrice.toDouble());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.entries.unitName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF603300),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                // Title of the chart
                title: ChartTitle(text: 'Price History'),

                // Primary X Axis configuration
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Colors.black),
                  axisLine: AxisLine(width: 2, color: Colors.black),
                ),

                // Primary Y Axis configuration
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(color: Colors.black),
                  axisLine: AxisLine(width: 2, color: Colors.black),
                ),

                // Series configuration
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: List.generate(
                      xValues.length,
                      (index) => SalesData(
                        label: xValues[index],
                        sales: yValues[index],
                      ),
                    ),
                    xValueMapper: (SalesData sales, _) => sales.label,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    color: Color(0xFF603300),
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],

                // Legend configuration
                legend: Legend(isVisible: false),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'All History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: xValues.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header row
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Data rows
                  final entry = entriesWithSameUnitName[index - 1];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${entry.entries.unitPrice}'),
                        Text(
                          '${day[entry.datetime.weekday - 1]} ${entry.datetime.year}-${entry.datetime.month}-${entry.datetime.day}',
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for chart data
class SalesData {
  final String label;
  final double sales;

  SalesData({required this.label, required this.sales});
}
