import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/services/db_service.dart';
import 'package:insta_clone/services/rtdb_service.dart';

import '../models/post.dart';

class MyFeedPage extends StatefulWidget {
  final PageController? pageController;
  const MyFeedPage({Key? key, this.pageController}) : super(key: key);
  static final String id = "my_feed_page";

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  var isLoading = false;

  List<Post> items = [];
  // String image_1 = "https://images.unsplash.com/photo-1529778873920-4da4926a72c2";
  // String image_2 = "https://images.unsplash.com/photo-1504006833117-8886a355efbf";
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
  }



  _apiPostList() async{
    var list = await DBService.loadFeeds();
    setState(() {
      items.clear();
      items = list;
    });
  }

  void _apiPostLike(Post post) async{
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnLike(Post post) async{
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Instagram", style: TextStyle(
          fontSize: 30,
          fontFamily: "Billabong",
          color: Colors.black
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              widget.pageController!.animateToPage(2, duration: Duration(microseconds: 200), curve: Curves.easeIn);
            },
            icon: Icon(Icons.camera_alt),
            color: Colors.black,
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index){
              return _itemOfPost(items[index]);
            },
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : SizedBox.shrink(),
        ],
      )
    );
  }

  Widget _itemOfPost(Post post){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(),
          //user
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: post.img_user.isEmpty ? Image(
                          image: AssetImage('assets/images/avatar.png'),
                          width: 40,
                          height: 40,
                        ): Image.network(
                          post.img_user,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.fullname, style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black
                          ),),

                          Text(post.date)
                        ],
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.more_horiz, weight: 40,),
                  onPressed: (){},
                )
              ],
            ),
          ),
          SizedBox(height: 8,),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error
            ),
            fit: BoxFit.cover,
          ),

          //like,share
          Row(
            children: [
              IconButton(
                  onPressed: (){
                    if(!post.liked){
                      _apiPostLike(post);
                    }else{
                      _apiPostUnLike(post);
                    }
                  },
                  icon: post.liked ? Icon(EvaIcons.heart, color: Colors.red, weight: 30,):
                  Icon(EvaIcons.heartOutline, color: Colors.black, weight: 30,)),
              IconButton(
                  onPressed: (){

                  },
                  icon: Icon(EvaIcons.share, weight: 30,)),
            ],
          ),
          //caption
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                text: post.caption,
                style: TextStyle(color: Colors.black)
              ),
            ),
          )
        ],
      ),
    );
  }
}
