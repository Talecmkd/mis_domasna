// lib/screens/orders_page.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: sampleOrders.isEmpty
          ? Center(child: Text('No orders yet!'))
          : ListView.builder(
        itemCount: sampleOrders.length,
        itemBuilder: (ctx, i) => _buildOrderItem(context, sampleOrders[i]),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Order order) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Order #${order.id}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
            ),
            trailing: Text(
              '\$${order.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Divider(),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: order.products
                .map(
                  (prod) => ListTile(
                title: Text(prod.name),
                trailing: Text('${prod.price.toStringAsFixed(2)} x 1'),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
