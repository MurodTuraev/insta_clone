import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/services/auth_service.dart';

import '../models/member_model.dart';
import '../models/post.dart';
import '../services/db_service.dart';
import '../services/file_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);
  static final String id = 'my_profile_page';

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  List<Post> items = [];
  bool isLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String fullname="", email = "", img_url = "";
  int count_posts = 0, count_followers = 0, count_following = 0;

  int axisCount = 2;

  _callList(){
    setState(() {
      axisCount = 1;
    });
  }

  _callGrid(){
    setState(() {
      axisCount = 2;
    });
  }

  _imgFromGallery() async {
    XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  _imgFromCamera() async {
    XFile? image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  void _apiChangePhoto() {
    if (_image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(_image!).then((downloadUrl) => {
      _apiUpdateUser(downloadUrl),
    });
  }

  _apiUpdateUser(String downloadUrl) async {
    Member member = await DBService.loadMember();
    member.img_url = downloadUrl;
    await DBService.updateMember(member);
    _apiLoadMember();
  }

  void _apiLoadMember() {
    setState(() {
      isLoading = true;
    });
    DBService.loadMember().then((value) => {
      _showMemberInfo(value),
    });
  }

  void _showMemberInfo(Member member) {
    setState(() {
      isLoading = false;
      this.fullname = member.fullname;
      this.email = member.email;
      this.img_url = member.img_url;
      // this.count_following = member.following_count;
      // this.count_followers = member.followers_count;
      _apiLoadPosts();
    });
  }

  _apiLoadPosts() {
    DBService.loadPosts().then((value) => {
      _resLoadPosts(value),
    });
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = posts.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadMember();
    _apiLoadPosts();
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Pick Photo'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Take Photo'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile", style: TextStyle(
          color: Colors.black,
          fontFamily: "Billabong",
          fontSize: 25
        ),),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app),
            color: Color.fromRGBO(247, 119, 55, 1),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                //myphoto
                GestureDetector(
                  onTap: (){
                    _showPicker(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                              width: 1.5,
                              color: Color.fromRGBO(247, 119, 55, 1)
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: img_url == null || img_url.isEmpty
                              ? Image(
                            image: AssetImage(
                                "assets/images/avatar.png"),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            img_url,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.purple,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                Text(fullname.toUpperCase(),style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 3,),
                Text(email,style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),),
                SizedBox(height: 20,),
                //mycounts
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(count_posts.toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 3,),
                              Text('Posts', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey
                              ),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(count_followers.toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 3,),
                              Text('Followers', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey
                              ),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(count_following.toString(), style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 3,),
                              Text('Following', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //select list or grid
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child:IconButton(
                        onPressed: (){
                          _callList();
                        },
                        icon: Icon(Icons.list_alt_outlined, weight: 30,),
                      ),),
                      Expanded(child:IconButton(
                        onPressed: (){
                          _callGrid();
                        },
                        icon: Icon(Icons.grid_view_outlined, weight: 30,),
                      ),),

                    ],
                  ),
                ),

                //mypost
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: axisCount
                    ),
                    itemCount: items.length,
                    itemBuilder: (ctx, index){
                      return _itemOfPost(items[index]);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemOfPost(Post post){
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.img_post,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 3,),
          Text(post.caption, style: TextStyle(
            color: Colors.black87.withOpacity(0.7)
          ),
          maxLines: 2,)
        ],
      ),
    );
  }
}
