import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/Group/repository/group_repository.dart';

final GroupControllerProvider = Provider((ref) {
  final grprepo = ref.read(GroupRepoProvider);
  return GroupController(grpRepository: grprepo, ref: ref);
});

class GroupController {
  final GroupRepository grpRepository;
  final ProviderRef ref;

  GroupController({required this.grpRepository, required this.ref});

  void createGroup(BuildContext context, String GrpName, File grpImage,
      List<Contact> selectedContacts) {
    grpRepository.CreateGroup(GrpName, grpImage, context, selectedContacts);
  }
}
