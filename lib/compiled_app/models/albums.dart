import 'package:json_annotation/json_annotation.dart';

part 'albums.g.dart';

@JsonSerializable()
class Albums {
  final int userId;
  final int id;
  final String title;

  const Albums({required this.id, required this.title, required this.userId});

  factory Albums.fromJson(Map<String, dynamic> json) => _$AlbumsFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumsToJson(this);
}
