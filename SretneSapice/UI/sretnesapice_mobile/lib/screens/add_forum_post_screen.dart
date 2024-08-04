import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/providers/forum_post_provider.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class AddForumPostScreen extends StatefulWidget {
  static const routeName = '/add_forum_post';
  const AddForumPostScreen({super.key});

  @override
  State<AddForumPostScreen> createState() => _AddForumPostScreenState();
}

class _AddForumPostScreenState extends State<AddForumPostScreen> {
  ForumPostProvider? _forumPostProvider = null;

  final int selectedIndex = 0;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _forumPostProvider = context.read<ForumPostProvider>();
  }

  bool _validateFields(String? title, String? postContent) {
    return title != null &&
        title.isNotEmpty &&
        postContent != null &&
        postContent.isNotEmpty;
  }

  void post() async {
    loading = true;
    try {
      String title = _titleController.text;
      String postContent = _contentController.text;
      List<String?> tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
      int userId = Authorization.user!.userId;

      String base64Image =
          _imageFile != null ? base64Encode(_imageFile!.readAsBytesSync()) : '';

      if (_validateFields(title, postContent)) {
        Map forumPost = {
          "userId": userId,
          "title": title,
          "postContent": postContent,
          "tags": tags.isEmpty ? null : tags,
          "photo": base64Image
        };

        await _forumPostProvider!.insert(forumPost);

        loading = false;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Post objavljen!"),
          ),
        );

        Future.delayed(Duration(seconds: 3), () {
          Navigator.popAndPushNamed(context, ForumPostListScreen.routeName);
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Nešto je pošlo po zlu! Nemoguće objaviti ovaj post."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        initialIndex: selectedIndex,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Novi post",
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 25),
                      _buildForm(),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            post();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 108, 21, 190))),
                        child: loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text("Objavi",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                      ),
                    ]),
              )),
        ));
  }

  Widget _buildForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 238, 235, 241),
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 121, 26, 222),
            ),
          ),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Naslov',
            labelStyle: TextStyle(color: Color.fromARGB(255, 108, 21, 190)),
            hintStyle: Theme.of(context).textTheme.labelMedium,
          ),
          controller: _titleController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Morate unijeti naslov!";
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 238, 235, 241),
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 121, 26, 222),
            ),
          ),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Sadržaj',
            labelStyle: TextStyle(color: Color.fromARGB(255, 108, 21, 190)),
            hintStyle: Theme.of(context).textTheme.bodySmall,
          ),
          maxLines: null,
          controller: _contentController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Morate unijeti sadržaj!";
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 238, 235, 241),
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 121, 26, 222),
            ),
          ),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Tagovi (razdvojeni zarezom)',
            labelStyle: TextStyle(color: Color.fromARGB(255, 108, 21, 190)),
            hintStyle: Theme.of(context).textTheme.bodySmall,
          ),
          controller: _tagsController,
        ),
      ),
      const SizedBox(height: 16),
      Row(children: [
        _imageFile != null
            ? SizedBox(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  backgroundImage: FileImage(_imageFile!),
                ),
              )
            : Icon(Icons.photo,
                size: 150, color: Color.fromARGB(255, 108, 21, 190)),
        TextButton.icon(
          onPressed: getImageFromGallery,
          icon: Image.asset(
            "assets/icons/staple.png",
            height: 20,
            width: 20,
          ),
          label: const Text(
            'Slika (opcionalno)',
          ),
        ),
      ])
    ]);
  }

  File? _imageFile;
  String? _base64Image;

  Future getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image != null ? File(image.path) : null;
    });
  }
}
