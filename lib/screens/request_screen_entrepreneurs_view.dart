import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RequestPageEntrepreneur(),
    );
  }
}

class RequestPageEntrepreneur extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPageEntrepreneur> {
  String description = "";
  String amount = "";
  String equity = "";
  String reason = "";
  String submittedAt = "";

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController equityController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController submittedAtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8EE),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Company photo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 16,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: buildTopWhiteButton("Edit", () {
                  openEditSheet(context);
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("Description (Short)"),
                  buildDisplayBox(description),
                  buildLabel("Amount Of Money"),
                  buildDisplayBox(amount),
                  buildLabel("Equity"),
                  buildDisplayBox(equity),
                  buildLabel("Why They Are Raising?"),
                  buildDisplayBox(reason),
                  buildLabel("SubmittedAt"),
                  buildDisplayBox(submittedAt),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTabButton("Founder", const Color(0xFF91C7E5)),
                      buildTabButton("Company", const Color(0xFF91C7E5)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      buildRoundButton("Statue", Colors.green,
                          textColor: Colors.white),
                      const SizedBox(height: 16),
                      buildRoundButton("Cancel", Colors.red,
                          textColor: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget buildDisplayBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF91C7E5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildRoundButton(String text, Color bgColor,
      {Color textColor = Colors.black}) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
        ),
      ),
    );
  }

  Widget buildTabButton(String text, Color bgColor,
      {Color textColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17, color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  void openEditSheet(BuildContext context) {
    descriptionController.text = description;
    amountController.text = amount;
    equityController.text = equity;
    reasonController.text = reason;
    submittedAtController.text = submittedAt;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildTopWhiteButton("Cancel", () {
                          Navigator.pop(context);
                        }),
                        const SizedBox(width: 8),
                        buildTopWhiteButton("Save", () {
                          setState(() {
                            description = descriptionController.text;
                            amount = amountController.text;
                            equity = equityController.text;
                            reason = reasonController.text;
                            submittedAt = submittedAtController.text;
                          });
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    buildEditBox("Description (Short)", descriptionController),
                    buildEditBox("Amount Of Money", amountController),
                    buildEditBox("Equity", equityController),
                    buildEditBox("Why They Are Raising?", reasonController,
                        maxLines: 3),
                    buildEditBox("SubmittedAt", submittedAtController),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildEditBox(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF91C7E5),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(border: InputBorder.none),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopWhiteButton(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
