import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sns_j/model/account.dart';
import 'package:sns_j/model/post.dart';
import 'package:sns_j/utils/Authentication.dart';
import 'package:sns_j/utils/firestore/posts.dart';
import 'package:sns_j/utils/firestore/users.dart';
import 'package:sns_j/view/account/edit_account_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authenticatioin.myAccount!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,left: 15,right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              foregroundImage: NetworkImage(myAccount.imagePath),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(myAccount.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                      Text('@${myAccount.userId}',style: TextStyle(color: Colors.grey),)
                                    ],
                                  ),
                                  OutlinedButton(
                                    onPressed: ()async{
                                      var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAccountPage()));
                                      if(result == true){
                                        setState(() {
                                          myAccount = Authenticatioin.myAccount!;
                                        });
                                      }
                                    },
                                    child: Text('更新'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(myAccount.selfIntroduction),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blue,width: 3)
                    ),
                  ),
                  child: Text('投稿',style: TextStyle(color: Colors.blue),),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: UserFirestore.users.doc(myAccount.id)
                      .collection('my_posts').orderBy('created_time',descending: true)
                      .snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<String> myPostIds = List.generate(snapshot.data!.docs.length, (index){
                          return snapshot.data!.docs[index].id;
                        });
                        return FutureBuilder<List<Post>?>(
                          future: PostFirestore.getPostFromIds(myPostIds),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context,index){
                                    Post post = snapshot.data![index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                      decoration: BoxDecoration(
                                        border: index==0 ? Border(
                                          top: BorderSide(color: Colors.grey),
                                          bottom: BorderSide(color: Colors.grey),
                                        ) : Border(bottom: BorderSide(color: Colors.grey)),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            foregroundImage: NetworkImage(myAccount.imagePath),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(myAccount.name,style: TextStyle(fontWeight: FontWeight.bold),),
                                                        Text('@${myAccount.userId}',style: TextStyle(color: Colors.grey),)
                                                      ],
                                                    ),
                                                    Text(DateFormat('M/d/yy').format(post.createdTime!.toDate())),
                                                  ],
                                                ),
                                                Text(post.content),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              );
                            }else{
                              return Container();
                            }
                          }
                        );
                      }else{
                        return Container();
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
