class Item {
  String id;
  String name;
  String description;
  String imageUrl;

  String get getId {
    return id;
  }

  set setId(String newId) {
    id = newId;
  }

  String get getName {
    return name;
  }

  set setName(String newName) {
    name = newName;
  }

  String get getDescription {
    return description;
  }

  set setDescription(String newDescription) {
    description = newDescription;
  }

  String get getImageUrl {
    return imageUrl;
  }

  set setImageUrl(String newImageUrl) {
    imageUrl = newImageUrl;
  }

  Item({required this.id, required this.name, required this.description, required this.imageUrl});

}