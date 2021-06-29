import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_us/variables.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'introauthscreen.dart';
class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String username = '';
  String profile_pic ;
  String imageurl ;
  bool dataIsThere = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  PickedFile imagefile;
  var anotherprofile;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getuserdata();

  }

  void getuserdata() async {
    DocumentSnapshot userDoc = await userCollection.doc(
        FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      username = userDoc['username'];
      profile_pic = userDoc['profile'];
      anotherprofile = profile_pic;
      dataIsThere = true;
    });
  }

  editProfile(int change) async {
    userCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
      if(change == 0) 'username': usernameController.text
      else
        'password': passwordcontroller.text
    });
    setState(() {
      username = usernameController.text;
      profile_pic=imageurl;
    });
    Navigator.pop(context);
    usernameController = TextEditingController();
    passwordcontroller = TextEditingController();
  }

  openEditProfileDialog() async {
    return showDialog(context: context, builder: (context) {
      return Dialog(
        child: Container(
          height: 400,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: usernameController,
                  style: mystyle(18, Colors.black),
                  decoration: InputDecoration(
                      labelText: "Update Username",
                      labelStyle: mystyle(16, Colors.grey)
                  ),
                ),
              ),
              SizedBox(height: 40,),
              InkWell(
                onTap: () => editProfile(0),
                child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    height: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: GradientColors.cherry)
                    ),
                    child: Center(
                      child: Text("Change username", style: mystyle(17, Colors
                          .white),),
                    )
                ),
              ),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: passwordcontroller,
                  style: mystyle(18, Colors.black),
                  decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: mystyle(16, Colors.grey)
                  ),
                ),
              ),
              SizedBox(height: 40,),
              InkWell(
                onTap: () => editProfile(2),
                child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    height: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: GradientColors.cherry)
                    ),
                    child: Center(
                      child: Text("Change Password", style: mystyle(17, Colors
                          .white),),
                    )
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => IntroAuthScreen()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: dataIsThere == false ? Center(
        child: CircularProgressIndicator(),
      ) : Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: GradientColors.facebookMessenger),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width / 2 - 64,
              top: MediaQuery
                  .of(context)
                  .size
                  .height / 3.1,
            ),
            child: ProfilePicture(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300,),
                Text(username, style: mystyle(40, Colors.black),
                  textAlign: TextAlign.center,),
                SizedBox(height: 30,),
                InkWell(
                  onTap: () => openEditProfileDialog(),
                  child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: GradientColors.coolBlues)
                      ),
                      child: Center(
                        child: Text(
                          "Edit Profile", style: mystyle(17, Colors.white),),
                      )
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: () => signOut(),
                  child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: GradientColors.cherry)
                      ),
                      child: Center(
                        child: Text(
                          "SignOut", style: mystyle(17, Colors.white),),
                      )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget BottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0
      ),
      child: Column(children: [
        Text(
          "Chose Profile Photo",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(onPressed: () {
              takephoto(ImageSource.camera);
              editProfile(1);
            },
                icon: Icon(Icons.camera),
                label: Text('Camera')
            ),
            TextButton.icon(onPressed: () {
              takephoto(ImageSource.gallery);
              editProfile(1);
            },
                icon: Icon(Icons.image),
                label: Text('Gallery')
            )
          ],
        )
      ],
      ),
    );
  }

  void takephoto(ImageSource source) async {
    final pickedfile = await picker.getImage(
        source: source);
    setState(() {
      imagefile = pickedfile;
      UploadImage();

    });
  }

  Widget ProfilePicture() {
    return Stack (
      children: <Widget>[
        CircleAvatar(
            radius: 64,
            backgroundImage: anotherprofile==null?NetworkImage('https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'):NetworkImage(anotherprofile)
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(context: context,
                builder: (build) => BottomSheet(),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        )
      ],
    );
  }

  UploadImage() async {
    //check permission in ios
    var userinside = await FirebaseAuth.instance.currentUser.uid;
    final _storage  =FirebaseStorage.instance  ;
    var myfile = File(imagefile.path);
    if (imagefile != null) {
     var snapshot = await  _storage.ref().child('user/profile/${userinside}').putFile(myfile);
     String downloadUrl = await snapshot.ref.getDownloadURL();
     imageurl = downloadUrl;
     await userCollection.doc(FirebaseAuth.instance.currentUser.uid).update(
        { if(imageurl!= null)'profile':imageurl}
     );
     DocumentSnapshot userDoc = await userCollection.doc(
         FirebaseAuth.instance.currentUser.uid).get();
     setState(() async {
       profile_pic = await userDoc['profile'];
       anotherprofile = profile_pic;
       initState();

     });
     print('this is ########3 ${imageurl}');
    }
    else {
      print('No path recieved');

    }
  }
}
