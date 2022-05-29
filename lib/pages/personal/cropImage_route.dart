import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hello_homework/common/Global.dart';
import 'package:image_crop/image_crop.dart';

class CropImageRoute extends StatefulWidget {
  CropImageRoute(this.image);

  File image; //原始图片路径

  @override
  _CropImageRouteState createState() => new _CropImageRouteState();
}

class _CropImageRouteState extends State<CropImageRoute> {
  double? baseLeft; //图片左上角的x坐标
  double? baseTop; //图片左上角的y坐标
  double? imageWidth; //图片宽度，缩放后会变化
  double? imageScale = 1; //图片缩放比例
  Image? imageView;
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.blue,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Crop.file(
              widget.image,
              key: cropKey,
              aspectRatio: 1.0,
              alwaysShowGrid: true,
            ),
          ),
          MaterialButton(
            color: Colors.white,
            onPressed: () {
              _crop(widget.image);
            },
            child: Text('ok'),
          ),
        ],
      ),
    ));
  }

  Future<void> _crop(File originalFile) async {
    print("我要裁剪");
    final crop = cropKey.currentState;
    print(crop?.area);
    final area = crop?.area;
    if (area == null) {
      //裁剪结果为空
      print('裁剪不成功');
    }
    await ImageCrop.requestPermissions().then((value) {
      if (value) {
        ImageCrop.cropImage(
          file: originalFile,
          area: area!,
        ).then((value) {
          print(value);
          upload(value);
        }).catchError(() {
          print('裁剪不成功');
        });
      } else {
        print("剪裁成功！");
        upload(originalFile);
      }
    });
  }

  ///上传头像
  void upload(File file) {
    // print(file.path.toString());
    // print("上边是头像文件的地址！");
    Navigator.pop(context, '');
    MultipartFile multipartFile1 = MultipartFile.fromFileSync(
      file.path,
      filename: 'image.jpg',
    );
    Dio dio = Dio();
    FormData multipartFile = FormData.fromMap({
      "multipartFile": multipartFile1,
    });
    dio
        .post(Global.baseURL + '/uploadAvatar', data: multipartFile)
        .then((response) {
      print(response.data);
      print("上传成功");
      //处理上传结果
      var url = response.data['data'];
      print(url);
      if (response.data['flag'] == true) {
        setState(() {
          Global.avater = url;
        });
        Navigator.pop(context, url.toString()); //这里的url在上一页调用的result可以拿到
      } else {
        Navigator.pop(context, '');
      }
    });
  }
}
