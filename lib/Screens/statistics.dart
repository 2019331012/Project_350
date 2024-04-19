import 'package:flutter/material.dart';
import 'package:managment/data/dateAction.dart';
import 'package:managment/data/utlity.dart';
import 'package:managment/widgets/chart.dart';
import '../data/model/add_date.dart';

class Statistics extends StatefulWidget {
    const Statistics({Key? key}) : super(key: key);

    @override
    State<Statistics> createState() => _StatisticsState();
}

ValueNotifier<int> kj = ValueNotifier(0);
ValueNotifier<bool> sortOrderAscending = ValueNotifier(false); // Initialize as false (highest to lowest)

class _StatisticsState extends State<Statistics> {
    List<String> dayOptions = ['Day', 'Week', 'Month', 'Year'];
    final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    List<List<Add_data>> dataIntervals = [today(), week(), month(), year()];
    int currentDayIndex = 0;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: RefreshIndicator(
                onRefresh: () async {
                    // Refresh the page by reloading the data.
                    setState(() {});
                },
                child: SafeArea(
                    child: ValueListenableBuilder<int>(
                        valueListenable: kj,
                        builder: (context, value, child) {
                            return buildContent(dataIntervals[value]);
                        },
                    ),
                ),
            ),
        );
    }

    Widget buildContent(List<Add_data> data) {
        // Retrieve unique dates and sort them based on current sort order
        List<DateTime> sortedUniqueDates = getSortedUniqueDates();

        return CustomScrollView(
            slivers: [
                SliverToBoxAdapter(
                    child: Column(
                        children: [
                            SizedBox(height: 20),
                            Text(
                                'Statistics',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                ),
                            ),
                            SizedBox(height: 20),
                            buildDayOptions(),
                            SizedBox(height: 20),
                            Chart(indexx: currentDayIndex),
                            SizedBox(height: 20),
                            buildTopSpendingSection(),
                        ],
                    ),
                ),
                // SliverList built with sorted unique dates
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) {
                            final DateTime dateTime = sortedUniqueDates[index];
                            final List<Add_data> histories = DateAction.getHistoriesByDate(box, dateTime);
                            final sortedHistories = sortHistories(histories, sortOrderAscending.value);
                            double total = calculateTotalAmount(sortedHistories);
                            return ExpansionTile(
                                leading: Icon(Icons.arrow_drop_down),
                                title: Text(
                                    '${weekdays[dateTime.weekday - 1]} ${dateTime.year}-${dateTime.month}-${dateTime.day}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                                subtitle: Text(
                                    'Contains a list of entries of that time.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                                trailing: Text(
                                    '${total.abs()}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19,
                                        color: total > 0 ? Colors.green : Colors.red,
                                    ),
                                ),
                                children: sortedHistories.map((history) => ListTile(
                                    leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset('images/${history.name}.png', height: 40),
                                    ),
                                    title: Text(
                                        history.name,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                    subtitle: Text(
                                        '${history.datetime.year}-${history.datetime.month}-${history.datetime.day}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                    trailing: Text(
                                        '${history.entries.total}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 19,
                                            color: history.IN == 'Income' ? Colors.green : Colors.red,
                                        ),
                                    ),
                                )).toList(),
                            );
                        },
                        childCount: sortedUniqueDates.length,
                    ),
                ),
            ],
        );
    }

    Widget buildDayOptions() {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    4,
                    (index) {
                        return GestureDetector(
                            onTap: () {
                                setState(() {
                                    currentDayIndex = index;
                                    kj.value = index;
                                });
                            },
                            child: Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentDayIndex == index ? Color(0xFF603300) : Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                    dayOptions[index],
                                    style: TextStyle(
                                        color: currentDayIndex == index ? Colors.white : Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                            ),
                        );
                    },
                ),
            ),
        );
    }

    Widget buildTopSpendingSection() {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                        'Sorted Spending',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    // Sort order toggle button
                    ValueListenableBuilder<bool>(
                        valueListenable: sortOrderAscending,
                        builder: (context, ascending, child) {
                            return IconButton(
                                icon: Icon(
                                    ascending ? Icons.arrow_downward : Icons.arrow_upward,
                                    color: Colors.grey,
                                ),
                                onPressed: () {
                                    // Toggle the sort order
                                    setState(() {
                                        sortOrderAscending.value = !ascending;
                                    });
                                },
                            );
                        },
                    ),
                ],
            ),
        );
    }

    List<DateTime> getSortedUniqueDates() {
        // Calculate the total absolute amount for each date
        List<DateTime> uniqueDates = DateAction.getUniqueDates(box);
        Map<DateTime, double> dateToTotalMap = {};

        // Calculate the total absolute amount for each date and store in map
        for (var date in uniqueDates) {
            List<Add_data> histories = DateAction.getHistoriesByDate(box, date);
            double total = calculateTotalAmount(histories);
            dateToTotalMap[date] = total.abs();
        }

        // Sort uniqueDates list based on total absolute amount and sortOrderAscending
        uniqueDates.sort((a, b) {
            double totalA = dateToTotalMap[a] ?? 0;
            double totalB = dateToTotalMap[b] ?? 0;
            return sortOrderAscending.value ? totalA.compareTo(totalB) : totalB.compareTo(totalA);
        });

        return uniqueDates;
    }

    List<Add_data> sortHistories(List<Add_data> histories, bool ascending) {
        List<Add_data> sortedHistories = List.from(histories);
        sortedHistories.sort((a, b) {
            double totalA = a.entries.total;
            double totalB = b.entries.total;
            return ascending ? totalA.compareTo(totalB) : totalB.compareTo(totalA);
        });
        return sortedHistories;
    }
}
