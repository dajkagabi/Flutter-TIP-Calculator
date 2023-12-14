import 'package:flutter/material.dart';

// Pénznemek felsorolása
enum Currency { USD, EUR, HUF, GBP, CHF }

class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  double billAmount = 0.0;
  int tipPercentage = 0;
  Currency selectedCurrency = Currency.USD;

  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tip Calculator'),
          actions: [
            // Világos/sötét téma váltó gomb
            IconButton(
              icon: _buildThemeToggleButton(),
              onPressed: () {
                setState(() {
                  isDarkTheme = !isDarkTheme;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Számlaösszeg bevitele
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // Bill Amount részénél csak a pénznem ikonja változzon meg
                  labelText: 'Bill Amount ${currencyIcon(selectedCurrency)}',
                ),
                onChanged: (value) {
                  setState(() {
                    billAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              // Borravaló százalék kiválasztása
              Row(
                children: [
                  const Text('Tip Percentage: '),
                  DropdownButton<int>(
                    value: tipPercentage,
                    items: [0, 10, 15, 20].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value%'),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        tipPercentage = value ?? 0;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Pénznem kiválasztása
              Row(
                children: [
                  const Text('Currency: '),
                  DropdownButton<Currency>(
                    value: selectedCurrency,
                    items: Currency.values.map((Currency currency) {
                      return DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text(currencyToString(currency)),
                      );
                    }).toList(),
                    onChanged: (Currency? value) {
                      setState(() {
                        selectedCurrency = value ?? Currency.USD;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Számolás gomb és eredmények megjelenítése párbeszédablakban
              ElevatedButton(
                onPressed: () {
                  double tipAmount = (billAmount * tipPercentage) / 100;
                  double totalAmount = billAmount + tipAmount;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Result'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Bill Amount: ${formatCurrency(billAmount, selectedCurrency)}'),
                            Text(
                                'Tip Amount: ${formatCurrency(tipAmount, selectedCurrency)}'),
                            const Divider(),
                            Text(
                                'Total Amount: ${formatCurrency(totalAmount, selectedCurrency)}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Téma váltó gomb widget
  Widget _buildThemeToggleButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: isDarkTheme
          ? const Icon(
              Icons.wb_sunny,
              key: Key('sunny'),
            )
          : const Icon(
              Icons.nightlight_round,
              key: Key('night'),
            ),
    );
  }

  // Pénznem felsorolás string reprezentációja
  String currencyToString(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return 'USD';
      case Currency.EUR:
        return 'EUR';
      case Currency.HUF:
        return 'HUF';
      case Currency.GBP:
        return 'GBP';
      case Currency.CHF:
        return 'CHF';
      default:
        return '';
    }
  }

  // Pénzösszeg formázása pénznem szerint
  String formatCurrency(double amount, Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$${amount.toStringAsFixed(2)}';
      case Currency.EUR:
        return '€${amount.toStringAsFixed(2)}';
      case Currency.HUF:
        return 'HUF ${amount.toStringAsFixed(0)}';
      case Currency.GBP:
        return '£${amount.toStringAsFixed(2)}';
      case Currency.CHF:
        return 'CHF ${amount.toStringAsFixed(2)}';
      default:
        return '';
    }
  }

  // Pénznem ikon visszaadása a megadott pénznem alapján
  String currencyIcon(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.EUR:
        return '€';
      case Currency.HUF:
        return 'HUF';
      case Currency.GBP:
        return '£';
      case Currency.CHF:
        return 'CHF';
      default:
        return '';
    }
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: TipCalculator(),
    ),
  );
}
