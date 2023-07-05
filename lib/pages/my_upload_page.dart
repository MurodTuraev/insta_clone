import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/services/db_service.dart';
import 'package:insta_clone/services/file_service.dart';
import 'package:insta_clone/services/rtdb_service.dart';
import 'package:insta_clone/services/store_service.dart';

class MyUploadPage extends StatefulWidget {
  final PageController? pageController;
  const MyUploadPage({Key? key, this.pageController}) : super(key: key);
  static final String id = "my_upload_page";

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {

  var isLoading = false;
  var captionController = TextEditingController();
  final _picker = ImagePicker();
  File? _image;
  var _bottomSheet = false;

  _openBottomSheet(){
    setState(() {
      if (_bottomSheet){
        _bottomSheet = false;
      }else{
        _bottomSheet = true;
      }
    });
  }

  _uploadNewPost(){
    String caption = captionController.text.toString().trim();

    if(caption.isEmpty)return;
    if(_image == null) return;
    _apiPostImage();
  }

  void _apiPostImage(){
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(_image!).then((value) => {
      _resPostImage(value),
    });
  }

  void _resPostImage(String downloadUrl){
    String caption = captionController.text.toString().trim();
    Post post = Post(caption, downloadUrl);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async{
    Post posted = await DBService.storePost(post);
    DBService.storeFeed(posted).then((value) => {
      _moveToFeed(),
    });
  }


  _moveToFeed(){
    setState(() {
      isLoading = false;
    });
    captionController.text = "";
    _image = null;
    widget.pageController!.animateToPage(0,
        duration: Duration(microseconds: 200),
        curve: Curves.easeIn);
  }


  Future _imgFromGallery() async{
    final image = await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future _imgFromCamera() async{
    final image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Upload", style: TextStyle(
          color: Colors.black
        ),),
        actions: [
          IconButton(
            onPressed: (){
              _uploadNewPost();
            },
            icon: Icon(Icons.drive_folder_upload),
            color: Color.fromRGBO(247, 119, 55, 1),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _openBottomSheet();
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.4),
                      child: _image == null ? Center(
                        child: Icon(Icons.add_a_photo, size: 50,
                          color: Colors.grey,),
                      ) : Stack(
                        children: [
                          Image.file(_image!, width: double.infinity, height: double.infinity,fit: BoxFit.cover,),
                          Container(
                            width: double.infinity,
                            color: Colors.black38,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _image=null;
                                    });
                                  },
                                  icon: Icon(Icons.highlight_remove),
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                    child: TextField(
                      controller: captionController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Caption',
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.black38
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) :
              SizedBox.shrink(),
        ],
      ),
      bottomSheet: _bottomSheet
      ? BottomSheet(
        // elevation: 10,
        enableDrag: false,
        backgroundColor: Colors.green.withOpacity(0.2),
        onClosing: () {},
        builder: (BuildContext ctx) => Container(
          width: double.infinity,
          height: 100,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.photo_library_outlined, color: Colors.grey,),
                  SizedBox(width: 20,),
                  TextButton(
                    onPressed: (){
                      _imgFromGallery();
                    },
                    child: Text("Pick Photo", style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20
                    ),),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(Icons.camera_alt_outlined, color: Colors.grey,),
                  SizedBox(width: 20,),
                  TextButton(
                    onPressed: (){
                      _imgFromCamera();
                    },
                    child: Text("Take Photo", style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20
                    ),),
                  )
                ],
              ),
            ],
          ),
        ),
      ): null,
    );
  }
}
