import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/data_in_expensiontile.dart';
import '../../widgets/custom_button.dart';

class DropdownDataPage extends StatefulWidget {
  @override
  _DropdownDataPageState createState() => _DropdownDataPageState();
}

class _DropdownDataPageState extends State<DropdownDataPage> {
  late List<Map<String, dynamic>> _documents;
  String? _selectedItem;
  String _title = "Select an Item";

  @override
  void initState() {
    super.initState();
    _documents = [];
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('try').get();
      final documents = snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        _documents = documents;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _title,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedItem,
              hint: Text('Select an item'),
              onChanged: (String? value) {
                setState(() {
                  _selectedItem = value;
                });
              },
              items: _documents.map((item) {
                return DropdownMenuItem<String>(
                  value: item['type'],
                  child: Text(item['type']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedItem != null)
              Column(
                children: [
                  Text(
                    'Selected Item: $_selectedItem',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Details:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                 _getDetails(_selectedItem!),
                ],
              ),


            SizedBox(height: 40,),
            custombutton2(text: "ExpansionTile",fontColor: Colors.white,ontap: (){Get.to(()=>FirestoreExpansionTile());}),
            SizedBox(height: 40,),

          ],
        ),
      ),
    );
  }
  Widget _getDetails(String itemName) {
    final item = _documents.firstWhere((element) => element['type'] == itemName);
    final age = item['fruit'];
    final hobbies = item['veg'] != null
        ? List<String>.from(item['veg'].map((hobby) => hobby.toString()))
        : [];
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(
            'Age: $age',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(
            'Hobbies:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(hobbies.join(", ")),
        ),
      ],
    );
  }
}

