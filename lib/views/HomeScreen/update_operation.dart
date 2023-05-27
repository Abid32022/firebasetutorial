import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:start/widgets/custom_button.dart';

class UpdateDataScreen extends StatefulWidget {
  @override
  _UpdateDataScreenState createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _field1Controller,
                decoration: InputDecoration(
                  labelText: 'Field 1',
                ),
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Field 1 cannot be empty';
                //   }
                //   return null;
                // },
              ),
              TextFormField(
                controller: _field2Controller,
                decoration: InputDecoration(
                  labelText: 'Field 2',
                ),
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Field 2 cannot be empty';
                //   }
                //   return null;
                // },
              ),
              SizedBox(height: 16.0),

               custombutton2(
                 text: "Update",fontColor: Colors.white,
                 ontap: ()async{
                   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                     // Get a reference to the document to update
                     final documentRef = FirebaseFirestore.instance.collection('collection_name').doc('document_id');

                     try {
                       // Use the update() method to update the document
                       await documentRef.update({
                         'field1': _field1Controller.text,
                         'field2': _field2Controller.text,
                         // add more fields to update as needed
                       });
                       print('Document updated successfully!');
                       Navigator.pop(context);
                     } catch (e) {
                       print('Error updating document: $e');
                       // Show an error dialog if there was an error updating the document
                       showDialog(
                         context: context,
                         builder: (context) => AlertDialog(
                           title: Text('Error'),
                           content: Text('There was an error updating the document. Please try again later.'),
                           actions: [

                           ],
                         ),
                       );
                     }
                   }
                 }
               )
            ],
          ),
        ),
      ),
    );
  }
}
