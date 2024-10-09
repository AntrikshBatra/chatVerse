import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/features/Group/screens/createGroupScreen.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_screen.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_clone/features/status/screens/confirmStatusScreen.dart';
import 'package:whatsapp_clone/features/status/screens/statusScreen.dart';

class MobileLayout extends ConsumerStatefulWidget {
  const MobileLayout({super.key});

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(AuthControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(AuthControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            title: Text("Whatsapp",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            centerTitle: false,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
              PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Create Group'),
                          onTap: () => Future(() =>
                              Navigator.pushNamed(context, CreateGroup.route)),
                        )
                      ])
            ],
            bottom: TabBar(
              controller: tabBarController,
              indicatorColor: tabColor,
              labelColor: tabColor,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 4,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [Text("CHATS"), Text("STATUS"), Text("CALLS")],
            ),
          ),
          body: TabBarView(controller: tabBarController, children: [
            ContactsList(),
            StatusContactsScreen(),
            const Text('Calls')
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tabBarController.index == 0) {
                Navigator.pushNamed(context, SelectContactScreen.route);
              } else {
                File? pickedImage = await pickImage(context);
                if (pickedImage != null) {
                  Navigator.pushNamed(context, ConfirmStatusScreen.route,
                      arguments: pickedImage);
                }
              }
            },
            backgroundColor: tabColor,
            child: Icon(
              tabBarController.index == 0 ? Icons.comment : Icons.done,
              color: Colors.white,
            ),
          ),
        ));
  }
}
