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
    final List<Add_data> entriesWithSameUnitName = box.values.where((entry) => entry.entries.unitName == item.entries.unitName).toList();

    // Extract x and y values
    final List<String> xValues = entriesWithSameUnitName.map((entry) => _formatDateTime(entry.datetime)).toList();
    final List<double> yValues = entriesWithSameUnitName.map((entry) => entry.entries.unitPrice.toDouble()).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(item.entries.unitName), // Display unit name in the app bar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: entriesWithSameUnitName.length,
              itemBuilder: (context, index) {
                final entry = entriesWithSameUnitName[index];
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
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: xValues.asMap().entries.map((entry) => SalesData(entry.key, entry.value, yValues[entry.key])).toList(),
                    xValueMapper: (SalesData sales, _) => sales.label,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
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
