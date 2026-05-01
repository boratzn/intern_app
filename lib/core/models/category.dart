/// Supabase `categories` tablosunu temsil eder.
/// Alanlar: id (int), category_name (text)
class Category {
  final int id;
  final String categoryName;

  const Category({required this.id, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      categoryName: json['category_name'] as String,
    );
  }

  @override
  bool operator ==(Object other) => other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
