import 'package:json_annotation/json_annotation.dart';

part 'addBlogModels.g.dart';

@JsonSerializable()
class AddBlogModel {
  String coverImage;
  int count;
  int share;
  int comment;
  @JsonKey(name: "_id")
  String id;
  String username;
  String title;
  String body;

  AddBlogModel(
      {required this.coverImage,
      required this.count,
      required this.share,
      required this.comment,
      required this.id,
      required this.username,
      required this.body,
      required this.title});
  factory AddBlogModel.fromJson(Map<String, dynamic> json) =>
      _$AddBlogModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddBlogModelToJson(this);
}