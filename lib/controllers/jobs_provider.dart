import 'package:flutter/material.dart';
import 'package:job_look/models/response/jobs/jobs_response.dart';
import 'package:job_look/services/helpers/jobs_helper.dart';

class JobsNotifier extends ChangeNotifier {
  // Regular jobs state
  List<JobsResponse>? _jobs;
  bool _isLoading = false;
  String? _error;

  // Recent jobs state
  List<JobsResponse>? _recentJobs;
  bool _isLoadingRecent = false;
  String? _recentError;

  // Track search-specific states
  bool _isSearchLoading = false;
  String? _searchError;
  final Map<String, List<JobsResponse>> _searchCache = {}; // Cache for search results

  // Getters remain the same
  List<JobsResponse>? get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<JobsResponse>? get recentJobs => _recentJobs;
  bool get isLoadingRecent => _isLoadingRecent;
  String? get recentError => _recentError;
  bool get isSearchLoading => _isSearchLoading;
  String? get searchError => _searchError;

  // Improved constructor - delay initialization
  JobsNotifier() {
    // Use a longer delay to ensure UI renders first
    Future.delayed(Duration(milliseconds: 300), () {
      // Load one at a time to reduce simultaneous network requests
      getJobs().then((_) => getRecentJobs());
    });
  }

  // Optimized getJobs method
  Future<List<JobsResponse>> getJobs() async {
    // Return cached data if available
    if (_jobs != null && _jobs!.isNotEmpty) {
      return _jobs!;
    }

    // Avoid the while loop that could block the thread
    if (_isLoading) {
      // Return empty list immediately instead of waiting
      return _jobs ?? [];
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final jobHelper = JobHelper();
      _jobs = await jobHelper.getJobs().timeout(
        Duration(seconds: 15), // Reduced timeout
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _jobs = [];
      print('Error in getJobs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _jobs ?? [];
  }

  // Optimized getRecentJobs
  Future<List<JobsResponse>> getRecentJobs() async {
    if (_recentJobs != null && _recentJobs!.isNotEmpty) {
      return _recentJobs!;
    }

    // Avoid the while loop that could block the thread
    if (_isLoadingRecent) {
      return _recentJobs ?? [];
    }

    _isLoadingRecent = true;
    _recentError = null;
    notifyListeners();

    try {
      final jobHelper = JobHelper();
      _recentJobs = await jobHelper.getRecent().timeout(
        Duration(seconds: 15), // Reduced timeout
        onTimeout: () {
          throw Exception('Recent jobs request timed out');
        },
      );
      _recentError = null;
    } catch (e) {
      _recentError = e.toString();
      _recentJobs = [];
      print('Error in getRecentJobs: $e');
    } finally {
      _isLoadingRecent = false;
      notifyListeners();
    }

    return _recentJobs ?? [];
  }

  // Improved search method with proper error handling and loading states
  Future<List<JobsResponse>> getSearchJob(String query) async {
    // Check cache first for quick response
    if (_searchCache.containsKey(query)) {
      return _searchCache[query]!;
    }

    // Set loading state
    _isSearchLoading = true;
    _searchError = null;
    notifyListeners();

    try {
      final jobHelper = JobHelper();
      final searchedJobs = await jobHelper
          .getSearchJob(query)
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Search request timed out');
            },
          );

      // Cache the results for this query
      _searchCache[query] = searchedJobs;

      return searchedJobs;
    } catch (e) {
      _searchError = e.toString();
      print('Error in getSearchJob: $e');
      // Return empty list on error
      return [];
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  // Method to refresh all jobs
  Future<void> refreshJobs() async {
    _jobs = null; // Clear cache
    _searchCache.clear(); // Clear search cache
    await getJobs();
  }

  // Method to refresh recent jobs
  Future<void> refreshRecentJobs() async {
    _recentJobs = null; // Clear cache
    await getRecentJobs();
  }

  // Method to refresh all data
  Future<void> refreshAllData() async {
    _jobs = null;
    _recentJobs = null;
    await Future.wait([getJobs(), getRecentJobs()]);
  }

  // Method to search jobs by title or company
  Future<List<JobsResponse>> searchJobs(String query) async {
    if (_jobs == null) {
      await getJobs();
    }

    if (_jobs == null || _jobs!.isEmpty) {
      return [];
    }

    query = query.toLowerCase();
    return _jobs!.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query);
    }).toList();
  }

  // Add a specific method to clear search cache
  void clearSearchCache() {
    _searchCache.clear();
    _searchError = null;
    notifyListeners();
  }
}
