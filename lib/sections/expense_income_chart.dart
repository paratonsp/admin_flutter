import 'package:admin_flutter/responsive.dart';
import 'package:admin_flutter/styles/styles.dart';
import 'package:admin_flutter/widgets/bar_chart_with_title.dart';
import 'package:flutter/cupertino.dart';

class ExpenseIncomeCharts extends StatelessWidget {
  const ExpenseIncomeCharts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Responsive.isDesktop(context)
        ? Row(
            children: [
              Flexible(
                child: BarChartWithTitle(
                  title: "Expanse",
                  amount: 5340,
                  barColor: Styles.defaultBlueColor,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: BarChartWithTitle(
                  title: "Income",
                  amount: 1980,
                  barColor: Styles.defaultRedColor,
                ),
              ),
            ],
          )
        : Column(
            children: [
              Flexible(
                child: BarChartWithTitle(
                  title: "Expanse",
                  amount: 5340,
                  barColor: Styles.defaultBlueColor,
                ),
              ),
              SizedBox(
                height: Styles.defaultPadding,
              ),
              Flexible(
                child: BarChartWithTitle(
                  title: "Income",
                  amount: 1980,
                  barColor: Styles.defaultRedColor,
                ),
              ),
            ],
          ));
  }
}
