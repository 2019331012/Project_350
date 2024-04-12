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

class _StatisticsState extends State<Statistics> {
  List<String> day = ['Day', 'Week', 'Month', 'Year'];
  final List<String> days = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];

  List<List<Add_data>> f = [today(), week(), month(), year()];
  int index_color = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: kj,
          builder: (BuildContext context, int value, Widget? child) {
            return custom(f[value]);
          },
        ),
      ),
    );
  }

  Widget custom(List<Add_data> a) {
    //Map<DateTime, List<Add_data>> groupedByDate = DateAction.getHistoriesByDate(a, );
    List<DateTime> uniqueDates = DateAction.getUniqueDates(box);

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              index_color = index;
                              kj.value = index;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index_color == index
                                  ? Color(0xFF603300)
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: index_color == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Chart(
                indexx: index_color,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Spending',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.swap_vert,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final DateTime dateTime = uniqueDates[index];
              final List<Add_data> histories = DateAction.getHistoriesByDate(box, dateTime);
              double total = calculateTotalAmount(histories);
              return ExpansionTile(
                leading: Icon(Icons.arrow_drop_down), // Add a down-arrow icon
                title: Text(
                  '${days[dateTime.weekday - 1]}  ${dateTime.year}-${dateTime.day}-${dateTime.month}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Contains a List of entries of that time.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '${total.abs()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: /*history.IN == 'Income'*/ total>0 ? Colors.green : Colors.red,
                  ),
                ),
                children: [
                  // ListTile(
                  //   title: Text(
                  //     '${dateTime.year}-${dateTime.month}-${dateTime.day}',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  ...histories.map((history) => ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset('images/${history.name}.png',
                              height: 40),
                        ),
                        title: Text(
                          history.name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${history.datetime.year}-${history.datetime.day}-${history.datetime.month}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Text(
                          '${history.entries.total}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: history.IN == 'Income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      )),
                ],
              );
            },
            childCount: uniqueDates.length,
          ),
        ),
      ],
    );
  }

}
