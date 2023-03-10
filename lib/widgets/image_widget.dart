import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
 final String urlImage;
 final double height;
 final double width;

 const ImageWidget(
  {Key? key, required this.urlImage, this.height = 180, this.width = 300})
     : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0,top: 20.0,right: 20.0,bottom: 15.0),
      child: CachedNetworkImage(
       placeholder: (context, url) => Image.asset('assets/noimage.jpg'),
       imageUrl: urlImage,
       alignment: Alignment.center,
       fit: BoxFit.fill,
     ),
    );
  }


}