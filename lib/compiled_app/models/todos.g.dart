// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todos _$TodosFromJson(Map<String, dynamic> json) => Todos(
      json['userId'] as int,
      json['id'] as int,
      json['title'] as String,
      json['completed'] as bool,
    );

Map<String, dynamic> _$TodosToJson(Todos instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
    };
