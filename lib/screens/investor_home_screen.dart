import 'package:depi_graduation_project/custom%20widgets/request_tile_investor_view.dart';
import 'package:flutter/material.dart';

class InvestorHomeScreen extends StatelessWidget {
  
  const InvestorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actionsPadding: EdgeInsets.only(right: 10),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
              size: 27,
            ),
          ),
        ],
      ),
      body: Center(
        child: RequestTileInvestorView(companyname: 'YourCompanyName', offer: '50000', equity: '10', date: '2024-06-15', description: 'bladfdhfghdfhbbfdhbfbhbfbfdhdhfbfghthfgbchfhfhgfhgfhgfhgfhgfhjgjhgdrhtr'),
      ),
    );
  }
}