import 'package:flutter/material.dart';
import 'package:sns_j/model/post.dart';
import 'package:sns_j/utils/Authentication.dart';
import 'package:sns_j/utils/firestore/posts.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規作成',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: contentController,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: ()async{
                Post newPost = Post(
                  content: contentController.text,
                  postAccountId: Authenticatioin.myAccount!.id,
                );
                var result = await PostFirestore.addPost(newPost);
                if(result == true){
                  Navigator.pop(context);
                }
              },
              child: Text('投稿'),
            ),
          ],
        ),
      ),
    );
  }
}
