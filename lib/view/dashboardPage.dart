// ignore_for_file: file_names

import 'package:admin_flutter/models/card_details.dart';
import 'package:admin_flutter/models/enums/card_type.dart';
import 'package:admin_flutter/responsive.dart';
import 'package:admin_flutter/sections/expense_income_chart.dart';
import 'package:admin_flutter/sections/latest_transactions.dart';
import 'package:admin_flutter/sections/statics_by_category.dart';
import 'package:admin_flutter/sections/upgrade_pro_section.dart';
import 'package:admin_flutter/sections/your_cards_section.dart';
import 'package:admin_flutter/styles/styles.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Main Panel
          Expanded(
            child: Column(
              children: [
                const Expanded(
                  flex: 2,
                  child: ExpenseIncomeCharts(),
                ),
                (Responsive.isDesktop(context))
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Styles.defaultPadding,
                          ),
                          child: const UpgradeProSection(),
                        ),
                      )
                    : SizedBox(
                        height: Styles.defaultPadding,
                      ),
                const Expanded(
                  flex: 2,
                  child: LatestTransactions(),
                ),
              ],
            ),
            flex: 5,
          ),
          // Right Panel
          Visibility(
            visible: Responsive.isDesktop(context),
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Styles.defaultPadding),
                child: Column(
                  children: [
                    CardsSection(
                      cardDetails: [
                        CardDetails("431421432", CardType.mastercard),
                        CardDetails("423142231", CardType.mastercard),
                      ],
                    ),
                    const Expanded(
                      child: StaticsByCategory(),
                    ),
                  ],
                ),
              ),
              flex: 2,
            ),
          )
        ],
      ),
    );
  }
}
