import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pollster_flutter/confirmation.dart';
import 'package:pollster_flutter/models/contacts.dart';
import 'package:masked_text/masked_text.dart';
import 'package:pollster_flutter/models/poll.dart';
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

class contactsWidget extends StatelessWidget{
//  final List<PollItem> pollItems;
  final String question;
  final List<String>? answers;

  const contactsWidget({required this.question, this.answers});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _ContactsWidget(question: question, answers: answers));
  }
}

class _ContactsWidget extends ConsumerWidget {
  //final List<PollItem> pollItems;
  final String question;
  final List<String>? answers;
  const _ContactsWidget({required this.question, required this.answers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          //child: SingleChildScrollView(
            //child: Container(
            //  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  const SelectedContactsListing(),
                  PhoneNumberEntry(),
                  const Expanded(
                    child:SingleChildScrollView(
                      child: ContactsListing()
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ContinueButton(question: question, answers: answers),
                  ),
                ]
            )
        )
      )
    );
  }
}


class PhoneNumberEntry extends ConsumerWidget {
  PhoneNumberEntry();
  final _textController = TextEditingController();

  void clearTextField() {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myContactsReader = ref.watch(myContactsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaskedTextField(
        controller: _textController,
        mask: "(###)-###-####", //TODO - make this region specific, or language pack specific
        keyboardType: TextInputType.phone, // Restricts input to numbers and symbols commonly used in phone numbers.
        //inputFormatters: [a
        //  FilteringTextInputFormatter.digitsOnly, // Only allows digits (0-9).
        //],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
        ),
        onFieldSubmitted: (String number) {
          debugPrint("[-] Adding contact to list: $number");
          myContactsReader.addNumber(number);
          clearTextField();
        },
      ),
    );
  }
}

class SelectedContactsListing extends ConsumerWidget {
  const SelectedContactsListing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myContactsWatcher = ref.watch(myContactsProvider);
    return Wrap(
      children: myContactsWatcher.selectedContacts.map(
        (selectedContact) {
          return MyClickableChip(
            label: selectedContact.displayName,
            onTap: () {
              final index = myContactsWatcher.selectedContacts.indexOf(selectedContact);
              debugPrint("[-] Removing contact from list: ${index.toString()} : ${selectedContact.displayName}");
              ref.read(myContactsProvider).removeContact(index);
            },
          );
        }
      ).toList(),
    );
  }
}

class MyClickableChip extends StatelessWidget {
  final String label;
  final Function onTap;

  const MyClickableChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Chip(
        label: Text(label),
      ),
    );
  }
}

class ContactsListing extends ConsumerWidget {
  const ContactsListing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myContactsWatcher = ref.watch(myContactsProvider);
    return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            itemCount: myContactsWatcher.contacts.length,
            itemBuilder: (context, i) {
              if (myContactsWatcher.contacts.isEmpty) {
                return const Center(child: Text("No contacts found"));
              } else {
                return Card(
                  child: ListTile(
                    title: Text(myContactsWatcher.contacts[i].displayName),
                    onTap: () {
                      debugPrint("[-] Adding contact to list: ${i.toString()}");
                      ref.read(myContactsProvider).addContact(i);
                      debugPrint("Done adding contact to list");
                    }
                  )
                );
              }
            }
          );
      }
  }


class ContinueButton extends ConsumerWidget {
  //final List<PollItem> pollItems;
  final String question;
  final List<String>? answers;
  const ContinueButton({required this.question, required this.answers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myContactsReader = ref.read(myContactsProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: const Text('Continue'),
        onPressed: () {
          debugPrint("Clicked on continue button: $question - ${answers.toString()}");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Confirmation(selectedContacts: myContactsReader.selectedContacts, question: question, answers: answers)),
          );
        },
      )
    );
  }
}