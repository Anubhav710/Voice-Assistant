import 'dart:convert';

import 'package:flutter/foundation.dart';

class MyMusicList {
  final List<MyMusic> musics;
  MyMusicList({
    required this.musics,
  });

  MyMusicList copyWith({
    List<MyMusic>? musics,
  }) {
    return MyMusicList(
      musics: musics ?? this.musics,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'musics': musics.map((x) => x.toMap()).toList()});
  
    return result;
  }

  factory MyMusicList.fromMap(Map<String, dynamic> map) {
    return MyMusicList(
      musics: List<MyMusic>.from(map['musics']?.map((x) => MyMusic.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMusicList.fromJson(String source) => MyMusicList.fromMap(json.decode(source));

  @override
  String toString() => 'MyMusicList(musics: $musics)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyMusicList &&
      listEquals(other.musics, musics);
  }

  @override
  int get hashCode => musics.hashCode;
}

class MyMusic {
  final int id;
  final String name;
  final String url;
  final String image;
  final String color;
  MyMusic({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.color,
  });
  

  MyMusic copyWith({
    int? id,
    String? name,
    String? url,
    String? image,
    String? color,
  }) {
    return MyMusic(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      image: image ?? this.image,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'url': url});
    result.addAll({'image': image});
    result.addAll({'color': color});
  
    return result;
  }

  factory MyMusic.fromMap(Map<String, dynamic> map) {
    return MyMusic(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      image: map['image'] ?? '',
      color: map['color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMusic.fromJson(String source) => MyMusic.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyMusic(id: $id, name: $name, url: $url, image: $image, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyMusic &&
      other.id == id &&
      other.name == name &&
      other.url == url &&
      other.image == image &&
      other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      url.hashCode ^
      image.hashCode ^
      color.hashCode;
  }
}
