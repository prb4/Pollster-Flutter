import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MyContactsChangeNotifier with ChangeNotifier {
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];

  MyContactsChangeNotifier() {
    _fetchContacts();
  }

  void addContact(int i) {
    if (! selectedContacts.contains(contacts[i])){
      debugPrint("Adding contact: ${i}: ${selectedContacts.length}");
      selectedContacts.add(contacts[i]);
      notifyListeners();
      debugPrint("Current size: ${selectedContacts.length}");
    } else {
      debugPrint("Contact already in selectedContacts list: ${contacts[i].displayName}");
    }
  }

  void removeContact(int i) {
    debugPrint("Removing contact");
    selectedContacts.remove(selectedContacts[i]);
    notifyListeners();
  }

  Contact createContact(String number) {
    final newContact = Contact();
    newContact.displayName = number;
    newContact.phones = [Phone(number)];

    return newContact;
  }

  void addNumber(String number) {
    if (! selectedContacts.contains(number)){
      debugPrint("Adding contact: $number");
      selectedContacts.add(createContact(number));
      notifyListeners();
      debugPrint("Current size: ${selectedContacts.length}");
    } else {
      debugPrint("Contact already in selectedContacts list: $number");
    }
  }

  Future _fetchContacts() async {
      //Call initially and with an 'refresh contacts' button
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      //permissionDenied = true; //TODO - may need to fix this
      //notifyListeners();
      debugPrint("Failed to get permissions");
      //TODO - this is bad
    } else {
      final _contacts = await FlutterContacts.getContacts();
      contacts = _contacts;
      notifyListeners();
      debugPrint("Got contacts in _fetch: ${contacts.length}");
    }
  }
}