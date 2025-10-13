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
  final String name;
  final String status;
  final String species;
  final String type;
  final String image;
  final String origin;

  Character({
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.image,
    required this.origin, // Место рождения или вселенной
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'] ?? '',
      image: json['image'],
      origin: json['origin']['name'], // Берем только название из origin объекта
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'image': image,
      'origin': origin,
    };
  }
}
