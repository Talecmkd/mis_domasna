import 'package:flutter/material.dart';

class PetAgeCalculatorScreen extends StatefulWidget {
  const PetAgeCalculatorScreen({Key? key}) : super(key: key);

  @override
  _PetAgeCalculatorScreenState createState() => _PetAgeCalculatorScreenState();
}

class _PetAgeCalculatorScreenState extends State<PetAgeCalculatorScreen> {
  String selectedPetType = 'Dog';
  double petAge = 1;
  int humanAge = 0;

  void calculateHumanAge() {
    setState(() {
      if (selectedPetType == 'Dog') {
        // Dog age calculation
        if (petAge <= 2) {
          humanAge = (petAge * 12).round();
        } else {
          humanAge = ((24 + (petAge - 2) * 4)).round();
        }
      } else {
        // Cat age calculation
        if (petAge <= 1) {
          humanAge = (petAge * 15).round();
        } else if (petAge <= 2) {
          humanAge = (15 + (petAge - 1) * 9).round();
        } else {
          humanAge = (24 + (petAge - 2) * 4).round();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Age Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculate Your Pet\'s Age in Human Years',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'Dog', label: Text('Dog')),
                ButtonSegment<String>(value: 'Cat', label: Text('Cat')),
              ],
              selected: {selectedPetType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selectedPetType = newSelection.first;
                  calculateHumanAge();
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Pet\'s Age (in years):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Slider(
              value: petAge,
              min: 0,
              max: 20,
              divisions: 40,
              label: petAge.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  petAge = value;
                  calculateHumanAge();
                });
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(
                    'Your ${selectedPetType.toLowerCase()} is approximately',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$humanAge human years old',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 