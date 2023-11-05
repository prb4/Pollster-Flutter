import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MyContactsChangeNotifier with ChangeNotifier {
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];

  MyContactsChangeNotifier() {
    _fetchContacts();
  }

  void addContact(int i) {
    debugPrint("Adding contact: ${i}: ${selectedContacts.length}");
    selectedContacts.add(contacts[i]);
    notifyListeners();
    debugPrint("Current size: ${selectedContacts.length}");
  }

  void removeContact(int i) {
    debugPrint("Removing contact");
    selectedContacts.remove(selectedContacts[i]);
    notifyListeners();
  }

  Future _fetchContacts() async {
      //Call initially and with an 'refresh contacts' button
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      //permissionDenied = true;
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