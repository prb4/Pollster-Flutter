import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/contacts.dart';
import 'package:provider/provider.dart';

Widget stateContacts() {
  
  return ChangeNotifierProvider(
    create: (context) => Updates(),
    child: FlutterContactsExample(),
  );
}

class Updates with ChangeNotifier {
  List<Contact>? _contacts = [];
  List<Contact>? selectedContacts = [];

  void addContact(int i) {
    debugPrint("Adding contact: ${i}: ${selectedContacts!.length}");
    selectedContacts!.add(_contacts![i]);
    notifyListeners();
    debugPrint("Current size: ${selectedContacts!.length}");
  }

  void removeContact() {
    debugPrint("Removing contact");
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      //permissionDenied = true;
      //notifyListeners();
      debugPrint("Failed to get permissions");
      //TODO - this is bad
    } else {
      final contacts = await FlutterContacts.getContacts();
      _contacts = contacts;
      notifyListeners();
      debugPrint("Got contacts in _fetch: ${_contacts!.length}");
      
    }
  }
}

class _FlutterContactsExample extends StatelessWidget {

  _FlutterContactsExample() {
      Updates()._fetchContacts();
      debugPrint("Finishing constructor");
    }

  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: const Text('flutter_contacts_example')),
          body: SingleChildScrollView(
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
                      //border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                    ),

                  )
                ),

                //Consumer<GetContacts>(builder: (context, value, child) =>
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: context.watch<Updates>()._contacts!.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text(context.watch<Updates>()._contacts![i].displayName),
                      onTap: () {
                        debugPrint("[-] Adding contact to list: ${i.toString()}");
                        context.read<Updates>().addContact(i);
                        debugPrint("Done adding contact to list");
                      }
                    )
                  ),
                //),

                ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () {
                        //Navigator.push(
                        //  context,
                        //  MaterialPageRoute(builder: (context) => FlutterContactsExample()),
                        debugPrint("Clicked on next button");
                      }
                  )
              ]
           )
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