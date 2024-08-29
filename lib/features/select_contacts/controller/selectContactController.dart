import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/select_contacts/repository/selectRepository.dart';

final getContactsProvider = FutureProvider(
  (ref) {
    final selectContactRepository =
        SelectContactRepository(firestore: FirebaseFirestore.instance);
    return selectContactRepository.getContacts();
  },
);

final SelectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(SelectContactRepositoryProvider);
  return SelectContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController(
      {required this.ref, required this.selectContactRepository});

  void selectContact(Contact selectedContact, BuildContext context) async {
    selectContactRepository.SelectContact(selectedContact, context);
  }
}
