class CharacterResponse {
  final Info info;
  final List<Character> results;

  CharacterResponse({
    required this.info,
    required this.results,
  });

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    return CharacterResponse(
      info: Info.fromJson(json['info']),
      results: (json['results'] as List).map((item) => Character.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class Info {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Info({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'pages': pages,
      'next': next,
      'prev': prev,
    };
  }
}

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String origin;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.origin,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()), // ← FIX
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? 'unknown',
      image: json['image'] ?? '',
      origin: json['origin'] is Map ? json['origin']['name'] ?? '' : json['origin'] ?? '', // ← FIX для кеша
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'origin': origin, // Уже строка, не объект
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Character && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
