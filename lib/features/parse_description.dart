import 'package:html/parser.dart';

parseDescriptionOfNews(description){
  description = parse(description);
  var textDescription = parse(description.body.text).documentElement?.text;
  return textDescription;
}

