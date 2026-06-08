import 'package:flutter/material.dart';
import '../models/exchange_rate.dart';
import '../services/api_service.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final ApiService apiService = ApiService();

  final TextEditingController amountController =
      TextEditingController(text: "100");

  String selectedCurrency = "VND";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Rate Helper"),
      ),
      body: FutureBuilder<ExchangeRate>(
        future: apiService.fetchRates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    "Something went wrong",
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;

          final currencies =
              data.rates.keys.toList();

          if (!currencies.contains(
              selectedCurrency)) {
            selectedCurrency =
                currencies.first;
          }

          double amount =
              double.tryParse(
                    amountController.text,
                  ) ??
                  0;

          double rate =
              (data.rates[selectedCurrency]
                      as num)
                  .toDouble();

          double result = amount * rate;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller:
                      amountController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Amount (USD)",
                    border:
                        OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 16),

                DropdownButton<String>(
                  value:
                      selectedCurrency,
                  isExpanded: true,
                  items: currencies
                      .map(
                        (currency) =>
                            DropdownMenuItem(
                          value: currency,
                          child:
                              Text(currency),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency =
                          value!;
                    });
                  },
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets
                            .all(16),
                    child: Column(
                      children: [
                        Text(
                          "$amount USD",
                          style:
                              const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(
                            height: 10),
                        Text(
                          "= ${result.toStringAsFixed(2)} $selectedCurrency",
                          style:
                              const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const SizedBox(
                            height: 10),
                        const Text(
                          "Helpful for travel and shopping decisions",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}