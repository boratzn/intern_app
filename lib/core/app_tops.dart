import 'package:flutter/material.dart';
import 'package:intern_app/core/models/category.dart';
import 'package:intern_app/core/models/student_profile.dart';
import 'package:intern_app/core/models/company_profile.dart';
import 'package:intern_app/core/models/job_listing.dart';

class AppTops {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  static List<String> appliedJobsIds = [];
  static List<JobListing> allJobs = [];
  static List<Category> categories = [];
  static StudentProfile? studentProfile;
  static CompanyProfile? companyProfile;
}
