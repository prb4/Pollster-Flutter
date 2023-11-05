import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pollster_flutter/models/contacts.dart';
//import 'package:provider/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/*

@riverpod
  Future<List<Contact>> fetchcontacts(FetchcontactsRef ref) async {
    List<Contact> contacts = [];
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      contacts = await FlutterContacts.getContacts();
      return contacts;
    }
    return contacts;
  }
*/
final myContactsProvider = ChangeNotifierProvider((ref) => MyContactsChangeNotifier());

Widget riverpodContacts() {
  return const ProviderScope(child: MyApp());
  
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  PhoneNumberEntry(),
                  ContactsListing(),
                ]
              )
            )
          )
        )
      )
    );
  }
}


class PhoneNumberEntry extends StatelessWidget {
  const PhoneNumberEntry();

  @override
  Widget build(BuildContext context) {
    return const Padding(
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
      ),
    );
  }
}

class ContactsListing extends ConsumerWidget {
  const ContactsListing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myContacts = ref.watch(myContactsProvider);
    return Consumer(
      builder: (context, ref, child) {
        
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            itemCount: myContacts.contacts.length,
            itemBuilder: (context, i) {
              if (myContacts.contacts.isEmpty) {
                return const Center(child: Text("List is empty"));
              } else {
                return ListTile(
                  title: Text(myContacts.contacts[i].displayName),
                  onTap: () {
                    debugPrint("[-] Adding contact to list: ${i.toString()}");
                    ref.read(myContactsProvider).addContact(i);
                    debugPrint("Done adding contact to list");
                  }
                );
              }
            }
          );
      }
        //return const Center(child: Text("List is empty"));
    );
  }
}
