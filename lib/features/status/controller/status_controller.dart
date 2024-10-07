import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/status/reppository/status_repository.dart';
import 'package:whatsapp_clone/models/status_model.dart';

final StatusControllerProvider = Provider((ref) {
  final StatusRepository statusRepository = ref.read(StatusRepositoryProvider);

  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(UserDataProvider).whenData((value) {
      statusRepository.uploadStatus(
          username: value!.name,
          statusImage: file,
          profilePic: value.profilePic,
          phoneNumber: value.phoneNumber,
          context: context);
    });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
