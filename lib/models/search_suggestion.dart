class SearchSuggestion {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final bool isPopular;

  const SearchSuggestion({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.isPopular = false,
  });
}
