import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join_us/authentication/verify.dart';
import 'package:join_us/variables.dart';
import 'package:join_us/videoconference/createmeeting.dart';
import 'package:join_us/videoconference/joinmeeting.dart';

class VideoConferenceScreen extends StatefulWidget {
  @override
  _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
}

class _VideoConferenceScreenState extends State<VideoConferenceScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  buildTab(String name) {
    return Container(
      width: 150,
      height: 50,
      child: Card(
        child: Center(
          child: Text(
            name,
            style: mystyle(15, Colors.black, FontWeight.w700),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser.emailVerified)
        ? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: Text(
          "JoinUs",
          style: mystyle(20, Colors.white, FontWeight.w700),
        ),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            buildTab("Join Meeting"),
            buildTab("Create Meeting"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [JoinMeeting(), CreateMeeting()],
      ),
    )
        : verify();
  }
}
