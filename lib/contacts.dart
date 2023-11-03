import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  List<Contact>? selectedContacts = [];
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }



  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('flutter_contacts_example')),
          body: _body()));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ContactsDisplay(_contacts);
  }
}

class ContactsDisplay extends StatelessWidget {
  final List<Contact>? _contacts;
  
  const ContactsDisplay(this._contacts);

  //final List<Contact>? selectedContacts = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              /*
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                itemCount: selectedContacts!.length,
                itemBuilder: (context, i) => ListTile(
                    title: Text(selectedContacts![i].displayName),
                    onTap: () async {
                      setState(() {
                            debugPrint("Removing contact from list: ${selectedContacts![i].name}");
                            selectedContacts!.removeAt(i);
                          });
                    })
                  ),
*/

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  //controller: _phoneNumberController,
                  keyboardType: TextInputType.phone, // Restricts input to numbers and symbols commonly used in phone numbers.
                  //inputFormatters: [
                  //  FilteringTextInputFormatter.digitsOnly, // Only allows digits (0-9).
                  //],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),

                )
              ),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                itemCount: _contacts!.length,
                itemBuilder: (context, i) => ListTile(
                    title: Text(_contacts![i].displayName),
                    onTap: () {
                      debugPrint("Adding contact to list");
                    })
                  ),

                  ElevatedButton(
                        child: const Text('Next'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FlutterContactsExample()),
                          );
                        },
                      )
              ]
            )
        )
    );
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}