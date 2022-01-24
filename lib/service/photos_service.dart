import 'package:dio/dio.dart';
import 'package:pagination_example/models/photos_model.dart';


class ServicePhotos{
  static Future<List<PhotoModel>> getPhotos(int start, int limit) async {
    print("START: $start");
    Response res = await Dio().get(
      "https://jsonplaceholder.typicode.com/photos?_start=$start&_limit=$limit"
    );
    print(res.data);
    return(res.data as List).map((e) => PhotoModel.fromJson(e)).toList();
  }
}