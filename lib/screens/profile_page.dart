// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy user data
  String _name = 'John Doe';
  String _email = 'johndoe@example.com';
  String _phone = '+1 234 567 8900';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      drawer: AppDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          SizedBox(height: 16),
          Text(_name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          SizedBox(height: 24),
          ListTile(
            title: Text('Email'),
            subtitle: Text(_email),
            trailing: Icon(Icons.edit),
            onTap: () => _showEditDialog('Email', _email),
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text(_phone),
            trailing: Icon(Icons.edit),
            onTap: () => _showEditDialog('Phone', _phone),
          ),
          ListTile(
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement change password functionality
            },
          ),
          ListTile(
            title: Text('Shipping Addresses'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to shipping addresses page
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String field, String currentValue) {
    TextEditingController _controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: field),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              setState(() {
                if (field == 'Email') {
                  _email = _controller.text;
                } else if (field == 'Phone') {
                  _phone = _controller.text;
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
