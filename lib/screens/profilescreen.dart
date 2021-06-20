import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:join_us/variables.dart';

import 'introauthscreen.dart';
class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username='';
  bool dataIsThere= false;
  TextEditingController usernameController= TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  void initState(){
    super.initState();
    getuserdata();
  }

  void getuserdata() async {
    DocumentSnapshot userDoc= await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      username=userDoc['username'];
      dataIsThere=true;
    });
  }
  editProfile()async{
    userCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
      'username':usernameController.text
    });
    setState(() {
      username=usernameController.text;
    });
    Navigator.pop(context);
  }
  openEditProfileDialog()async{
    return showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          height: 200,
            child: Column(
              children: [
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 30,right: 30) ,
                  child: TextField(
                    controller: usernameController,
                    style: mystyle(18,Colors.black),
                    decoration: InputDecoration(
                      labelText: "Update Username",
                      labelStyle: mystyle(16, Colors.grey)
                    ),
                  ),
                ),SizedBox(height: 40,),
                InkWell(
                  onTap: ()=>editProfile(),
                  child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: GradientColors.cherry)
                      ),
                      child: Center(
                        child:Text("Update Now",style: mystyle(17,Colors.white),),
                      )
                  ),
                ),
              ],
            ),
        ),
      );

    });
  }
  signOut()  async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => IntroAuthScreen()),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: dataIsThere==false?Center(
        child: CircularProgressIndicator(),
      ):Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: GradientColors.facebookMessenger),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width/2 -64,
              top: MediaQuery.of(context).size.height/3.1,
            ),
            child: CircleAvatar(
              radius: 64,
              backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300,),
                Text(username,style: mystyle(40,Colors.black),textAlign: TextAlign.center,),
                SizedBox(height: 30,),
                InkWell(
                  onTap: ()=>openEditProfileDialog(),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: GradientColors.coolBlues)
                      ),
                    child: Center(
                      child:Text("Edit Profile",style: mystyle(17,Colors.white),),
                    )
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: ()=>signOut(),
                  child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: GradientColors.cherry)
                      ),
                      child: Center(
                        child:Text("SignOut",style: mystyle(17,Colors.white),),
                      )
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: ()=>changepassword(),
                  child:Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: GradientColors.cherry)
                    ),
                    child: Center(
                    child: Text("Change password",style: mystyle(17, Colors.white)),
                    ),
                  ),
                )
                
              ],
            ),
          )
        ],
      ),
    );
  }

  changepassword() async{
    return showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          height: 200,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 30) ,
                child: TextField(
                  controller: passwordcontroller,
                  style: mystyle(18,Colors.black),
                  decoration: InputDecoration(
                      labelText: "Update password",
                      labelStyle: mystyle(16, Colors.grey)
                  ),
                ),
              ),SizedBox(height: 40,),
              InkWell(
                onTap: ()=>linksender(),
                child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: GradientColors.cherry)
                    ),
                    child: Center(
                      child:Text("password change",style: mystyle(18,Colors.white),),
                    )
                ),
              ),
            ],
          ),
        ),
      );

    });
  }

  linksender() {
    FirebaseAuth.instance.sendPasswordResetEmail(email: passwordcontroller.text );
    Navigator.of(context).pop();
  }

}

