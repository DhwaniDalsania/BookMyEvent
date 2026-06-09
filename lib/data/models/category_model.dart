import '../../constants/api_constants.dart';

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? iconUrl;

  CategoryModel({
    required this.id, 
    required this.name, 
    required this.slug, 
    this.iconUrl
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      iconUrl: ApiConstants.getFullImageUrl(json['iconUrl']),
    );
  }
}
