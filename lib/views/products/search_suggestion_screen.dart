import 'package:flutter/material.dart';
import '../../models/search_suggestion.dart';
import '../../widgets/cards/search_result_card.dart';

class SearchSuggestionScreen extends StatefulWidget {
  const SearchSuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SearchSuggestionScreen> createState() => _SearchSuggestionScreenState();
}

class _SearchSuggestionScreenState extends State<SearchSuggestionScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Static search suggestions data
  final List<SearchSuggestion> _allSuggestions = [
    SearchSuggestion(
      title: "Coffee",
      subtitle: "Beverages • 25 items",
      isPopular: true,
    ),
    SearchSuggestion(
      title: "Coffee Beans",
      subtitle: "Premium quality • 12 items",
    ),
    SearchSuggestion(
      title: "Coffee Maker",
      subtitle: "Appliances • 8 items",
    ),
    SearchSuggestion(
      title: "Coffee Filters",
      subtitle: "Accessories • 15 items",
    ),
    SearchSuggestion(
      title: "Coffee Mug",
      subtitle: "Drinkware • 32 items",
    ),
    SearchSuggestion(
      title: "Coffee Grinder",
      subtitle: "Tools • 6 items",
    ),
    SearchSuggestion(
      title: "Iced Coffee",
      subtitle: "Cold beverages • 18 items",
      isPopular: true,
    ),
    SearchSuggestion(
      title: "Espresso",
      subtitle: "Strong coffee • 9 items",
    ),
    SearchSuggestion(
      title: "Cappuccino",
      subtitle: "Milk coffee • 14 items",
      isPopular: true,
    ),
    SearchSuggestion(
      title: "Latte",
      subtitle: "Creamy coffee • 11 items",
    ),
  ];

  List<SearchSuggestion> _filteredSuggestions = [];
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = _allSuggestions;
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _showClearButton = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredSuggestions = _allSuggestions;
      } else {
        _filteredSuggestions = _allSuggestions
            .where((suggestion) =>
                suggestion.title.toLowerCase().contains(query.toLowerCase()) ||
                suggestion.subtitle.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4FC3F7)),
          onPressed: () => Navigator.pop(context),
        ),
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFF2C3E50),
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 22,
                ),
                suffixIcon: _showClearButton
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Results Header
              if (_filteredSuggestions.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Text(
                    _searchController.text.isEmpty
                        ? 'Popular Searches'
                        : 'Search Results (${_filteredSuggestions.length})',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
              ],

              // Search Results List
              Expanded(
                child: _filteredSuggestions.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredSuggestions.length,
                        itemBuilder: (context, index) {
                          return AnimatedSearchResultCard(
                            suggestion: _filteredSuggestions[index],
                            delay: index * 80,
                            onTap: () => _onSuggestionTapped(_filteredSuggestions[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _onSuggestionTapped(SearchSuggestion suggestion) {
    // Navigate to products screen with search filter
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: ${suggestion.title}'),
        backgroundColor: const Color(0xFF4FC3F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    
    // You can implement actual navigation like:
    // Navigator.pushNamed(context, '/products', arguments: suggestion.title);
  }
}
