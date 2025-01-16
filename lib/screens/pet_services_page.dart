import 'package:flutter/material.dart';
import '../models/pet_service.dart';
import '../widgets/app_drawer.dart';

class PetServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Services'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: sampleServices.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(context, sampleServices[index]);
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, PetService service) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(service.icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(service.name, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(service.description),
        trailing: Text('\$${service.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium),
        onTap: () {
          // TODO: Implement service booking or details page navigation
          print('Tapped on service: ${service.name}');
        },
      ),
    );
  }
}
