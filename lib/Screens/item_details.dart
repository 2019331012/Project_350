import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ItemDetailsPage extends StatelessWidget {
  final Add_data item;
  final Box<Add_data> box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'Friday',
    'Saturday',
    'Sunday'
  ];

  ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter entries with the same unit name as the provided item
    List<Add_data> entriesWithSameUnitName = box.values.where((entry) => entry.entries.unitName == item.entries.unitName).toList();

    // Sort the entries by date
    entriesWithSameUnitName.sort((a, b) => a.datetime.compareTo(b.datetime));

    // Group the sorted entries by day
    Map<String, List<Add_data>> groupedData = {};
    entriesWithSameUnitName.forEach((entry) {
      String dateKey = _formatDateTime(entry.datetime);
      if (groupedData.containsKey(dateKey)) {
        groupedData[dateKey]!.add(entry);
      } else {
        groupedData[dateKey] = [entry];
      }
    });

    // Extract x and y values for chart
    final List<String> xValues = groupedData.keys.toList();
    final List<double> yValues = xValues.map((dateKey) {
      double totalPrice = 0.0;
      groupedData[dateKey]!.forEach((entry) {
        totalPrice += entry.entries.unitPrice.toDouble();
      });
      return totalPrice;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.entries.unitName,
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Color(0xFF603300),
        iconTheme: IconThemeData(color: Colors.white), // Display unit name in the app bar
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
                  // Customize labels
                  labelStyle: TextStyle(color: Colors.black),
                  // Customize axis line
                  axisLine: AxisLine(width: 2, color: Colors.black),
                ),

                // Primary Y Axis configuration
                primaryYAxis: NumericAxis(
                  // Customize labels
                  labelStyle: TextStyle(color: Colors.black),
                  // Customize axis line
                  axisLine: AxisLine(width: 2, color: Colors.black),
                ),

                // Series configuration
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: xValues.asMap().entries.map((entry) => SalesData(entry.key, entry.value, yValues[entry.key])).toList(),
                    xValueMapper: (SalesData sales, _) => sales.label,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    // Customize color of the bars
                    color: Color(0xFF603300),
                    // Enable data labels
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
              itemCount: xValues.length + 1, // +1 for the header row
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
                  final dateKey = xValues[index - 1];
                  final entries = groupedData[dateKey]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        // child: Text(
                        //   '${day[entries.first.datetime.weekday - 1]}  ${entries.first.datetime.year}-${entries.first.datetime.day}-${entries.first.datetime.month}',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 16,
                        //   ),
                        // ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${entry.entries.unitPrice}'),
                                Text('${day[entry.datetime.weekday - 1]}  ${entry.datetime.year}-${entry.datetime.day}-${entry.datetime.month}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to format DateTime to display only day and month
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}';
  }
}

// Model class for chart data
class SalesData {
  final int year;
  final String label; // Modify to store day and month information
  final double sales;

  SalesData(this.year, this.label, this.sales); // Modify constructor accordingly
}
