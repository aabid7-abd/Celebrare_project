import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  File? _selectedImage;
   bool clipper = false;

  CustomClipper<Path>? _selectedClipper;

  Future _pickImageFromGallery() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value == null) return null;
      _cropImage(File(value.path));
    });
    // if (pickedImage == null) return null;
    //
    // setState(() {
    //   _selectedImage = File(pickedImage!.path);
    // });
  }

  Future _pickImageFromCamera() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return null;
    _cropImage(File(pickedImage.path));
    // setState(() {
    //   _selectedImage = File(pickedImage.path);
    // });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);

    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
      _showEventDialog(_selectedImage!);
      // reload();
    }
  }

  void _showEventDialog(File image) {
    showDialog(
      context: context,
      builder: (context) {
        // Return a Dialog widget
        return Dialog(
          child: Padding(
            padding:
            const EdgeInsets.all(10.0), // Apply padding around the content
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height *
                  0.5, // Set the height of the dialog
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                        width: 200,
                        height: 100,
                        child: Image.file(_selectedImage!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _applyClipper(RectangleClipper());

                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                              'assets/images/user_image_frame_2.png'),
                        ),
                      ),
                      //  const SizedBox(width: 10,),
                      InkWell(
                        onTap: () {
                          _applyClipper(HeartClipper());
                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                              'assets/images/user_image_frame_1.png'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                       _applyClipper(CircleClipper());
                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                              'assets/images/user_image_frame_3.png'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _applyClipper(rectClipper());

                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                              'assets/images/user_image_frame_4.png'),
                        ),
                      ),
                   SizedBox(
                          width: 30,
                          height: 30,
                          child: ElevatedButton(onPressed: (){
                            _applyClipper(DefaultClipper());

                          }, child: const Text(('Original')))
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Use This Image')) // Add a small gap
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 5.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.photo_library)),
                IconButton(
                    onPressed: () {
                      _pickImageFromCamera();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.camera))
              ],
            ),
          );
        });
  }

  void _applyClipper(CustomClipper<Path> clipper) {
    setState(() {
      _selectedClipper = clipper;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Image/Icon', style: TextStyle(color: Colors.black54),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.0, // Border width
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text('Upload Image'),
                    SizedBox(height: 10,),
                    ElevatedButton(
                        onPressed: () async {
                          showImagePicker(context);
                        },
                        child: const Text('Choose From Device')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            _selectedImage != null
                ?  ClipPath(
              clipper: _selectedClipper ?? DefaultClipper(),
              child: SizedBox(
                width: 500,
                height: 300,
                child: Image.file(_selectedImage!),
              ),
            ): Text(' ')
          ],
        ),
      ),
    );
  }
}
class rectClipper  extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.2916667,size.height*0.2900000);
    path_0.quadraticBezierTo(size.width*0.2895833,size.height*0.2200000,size.width*0.3333333,size.height*0.2157143);
    path_0.quadraticBezierTo(size.width*0.6158333,size.height*0.2178571,size.width*0.7100000,size.height*0.2185714);
    path_0.quadraticBezierTo(size.width*0.7450000,size.height*0.2214286,size.width*0.7500000,size.height*0.2871429);
    path_0.quadraticBezierTo(size.width*0.7500000,size.height*0.5528571,size.width*0.7500000,size.height*0.6414286);
    path_0.quadraticBezierTo(size.width*0.7500000,size.height*0.6964286,size.width*0.7100000,size.height*0.7128571);
    path_0.lineTo(size.width*0.3333333,size.height*0.7128571);
    path_0.quadraticBezierTo(size.width*0.2937500,size.height*0.7078571,size.width*0.2916667,size.height*0.6414286);
    path_0.cubicTo(size.width*0.2916667,size.height*0.5535714,size.width*0.2916667,size.height*0.5535714,size.width*0.2916667,size.height*0.2900000);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}
class HeartClipper extends CustomClipper<Path> {
  @override
  Path getClip(size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 0.3336333, size.height * 0.2226143);
    path_0.cubicTo(
        size.width * 0.3147250,
        size.height * 0.1316857,
        size.width * 0.2805750,
        size.height * 0.1226571,
        size.width * 0.2488500,
        size.height * 0.1273429);
    path_0.cubicTo(
        size.width * 0.2142583,
        size.height * 0.1400857,
        size.width * 0.1986250,
        size.height * 0.1731571,
        size.width * 0.1925917,
        size.height * 0.2163000);
    path_0.cubicTo(
        size.width * 0.1911917,
        size.height * 0.2487286,
        size.width * 0.1997417,
        size.height * 0.2755857,
        size.width * 0.2080333,
        size.height * 0.2985143);
    path_0.quadraticBezierTo(size.width * 0.2217000, size.height * 0.3425571,
        size.width * 0.3336250, size.height * 0.4783571);
    path_0.quadraticBezierTo(size.width * 0.4418333, size.height * 0.3536571,
        size.width * 0.4609083, size.height * 0.3038143);
    path_0.cubicTo(
        size.width * 0.4716750,
        size.height * 0.2802714,
        size.width * 0.4818583,
        size.height * 0.2549857,
        size.width * 0.4818167,
        size.height * 0.2134143);
    path_0.cubicTo(
        size.width * 0.4791333,
        size.height * 0.1658143,
        size.width * 0.4510750,
        size.height * 0.1314000,
        size.width * 0.4178833,
        size.height * 0.1256000);
    path_0.cubicTo(
        size.width * 0.3876583,
        size.height * 0.1199286,
        size.width * 0.3513167,
        size.height * 0.1308571,
        size.width * 0.3336333,
        size.height * 0.2226143);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class RectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(size) {
    final path = Path();
    // Define a rectangular path
    path.addRect(Rect.fromPoints(
        const Offset(20, 20), Offset(size.width - 20, size.height - 20)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.3316667,size.height*0.4985714);
    path_0.cubicTo(size.width*0.3327167,size.height*0.7152000,size.width*0.4172750,size.height*0.7818286,size.width*0.5008333,size.height*0.7861571);
    path_0.cubicTo(size.width*0.5810917,size.height*0.7860143,size.width*0.6668917,size.height*0.7155429,size.width*0.6675000,size.height*0.5000000);
    path_0.cubicTo(size.width*0.6659250,size.height*0.2892857,size.width*0.5826333,size.height*0.2142714,size.width*0.5008333,size.height*0.2128571);
    path_0.cubicTo(size.width*0.4198250,size.height*0.2139571,size.width*0.3329750,size.height*0.2900286,size.width*0.3316667,size.height*0.4985714);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DefaultClipper extends CustomClipper<Path> {
  @override
  Path getClip(size) {
    final path = Path();
    // Default clipping (no clipping)
    path.addRect(
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}