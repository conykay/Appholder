import 'package:json_annotation/json_annotation.dart';

part 'comments.g.dart';

@JsonSerializable()
class Comments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const Comments(
      {required this.postId,
      required this.id,
      required this.name,
      required this.email,
      required this.body});

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
