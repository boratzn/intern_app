// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i14;
import 'package:flutter/material.dart';
import 'package:intern_app/core/models/job_listing.dart';
import 'package:intern_app/ui/views/ai_job_generator/ai_job_generator_view.dart'
    as _i8;
import 'package:intern_app/ui/views/company_dashboard/company_dashboard_view.dart'
    as _i6;
import 'package:intern_app/ui/views/cv_viewer/cv_viewer_view.dart' as _i11;
import 'package:intern_app/ui/views/forgot_password/forgot_password_view.dart'
    as _i13;
import 'package:intern_app/ui/views/job_detail/job_detail_view.dart' as _i7;
import 'package:intern_app/ui/views/login/login_view.dart' as _i2;
import 'package:intern_app/ui/views/main/company_main/company_main_view.dart'
    as _i4;
import 'package:intern_app/ui/views/main/student_main/student_main_view.dart'
    as _i3;
import 'package:intern_app/ui/views/profile/company_profile/company_profile_view.dart'
    as _i10;
import 'package:intern_app/ui/views/profile/student_profile/student_profile_view.dart'
    as _i9;
import 'package:intern_app/ui/views/register/register_view.dart' as _i12;
import 'package:intern_app/ui/views/student_dashboard/student_dashboard_view.dart'
    as _i5;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i15;

class Routes {
  static const loginView = '/login-view';

  static const studentMainView = '/student-main-view';

  static const companyMainView = '/company-main-view';

  static const studentDashboardView = '/student-dashboard-view';

  static const companyDashboardView = '/company-dashboard-view';

  static const jobDetailView = '/job-detail-view';

  static const aiJobGeneratorView = '/ai-job-generator-view';

  static const studentProfileView = '/student-profile-view';

  static const companyProfileView = '/company-profile-view';

  static const cvViewerView = '/cv-viewer-view';

  static const registerView = '/register-view';

  static const forgotPasswordView = '/forgot-password-view';

  static const all = <String>{
    loginView,
    studentMainView,
    companyMainView,
    studentDashboardView,
    companyDashboardView,
    jobDetailView,
    aiJobGeneratorView,
    studentProfileView,
    companyProfileView,
    cvViewerView,
    registerView,
    forgotPasswordView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.loginView, page: _i2.LoginView),
    _i1.RouteDef(Routes.studentMainView, page: _i3.StudentMainView),
    _i1.RouteDef(Routes.companyMainView, page: _i4.CompanyMainView),
    _i1.RouteDef(Routes.studentDashboardView, page: _i5.StudentDashboardView),
    _i1.RouteDef(Routes.companyDashboardView, page: _i6.CompanyDashboardView),
    _i1.RouteDef(Routes.jobDetailView, page: _i7.JobDetailView),
    _i1.RouteDef(Routes.aiJobGeneratorView, page: _i8.AiJobGeneratorView),
    _i1.RouteDef(Routes.studentProfileView, page: _i9.StudentProfileView),
    _i1.RouteDef(Routes.companyProfileView, page: _i10.CompanyProfileView),
    _i1.RouteDef(Routes.cvViewerView, page: _i11.CvViewerView),
    _i1.RouteDef(Routes.registerView, page: _i12.RegisterView),
    _i1.RouteDef(Routes.forgotPasswordView, page: _i13.ForgotPasswordView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.LoginView(key: args.key),
        settings: data,
      );
    },
    _i3.StudentMainView: (data) {
      final args = data.getArgs<StudentMainViewArguments>(
        orElse: () => const StudentMainViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.StudentMainView(key: args.key),
        settings: data,
      );
    },
    _i4.CompanyMainView: (data) {
      final args = data.getArgs<CompanyMainViewArguments>(
        orElse: () => const CompanyMainViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.CompanyMainView(key: args.key),
        settings: data,
      );
    },
    _i5.StudentDashboardView: (data) {
      final args = data.getArgs<StudentDashboardViewArguments>(
        orElse: () => const StudentDashboardViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.StudentDashboardView(key: args.key),
        settings: data,
      );
    },
    _i6.CompanyDashboardView: (data) {
      final args = data.getArgs<CompanyDashboardViewArguments>(
        orElse: () => const CompanyDashboardViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.CompanyDashboardView(key: args.key),
        settings: data,
      );
    },
    _i7.JobDetailView: (data) {
      final args = data.getArgs<JobDetailViewArguments>(nullOk: false);
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.JobDetailView(key: args.key, job: args.job),
        settings: data,
      );
    },
    _i8.AiJobGeneratorView: (data) {
      final args = data.getArgs<AiJobGeneratorViewArguments>(
        orElse: () => const AiJobGeneratorViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.AiJobGeneratorView(key: args.key),
        settings: data,
      );
    },
    _i9.StudentProfileView: (data) {
      final args = data.getArgs<StudentProfileViewArguments>(
        orElse: () => const StudentProfileViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.StudentProfileView(key: args.key),
        settings: data,
      );
    },
    _i10.CompanyProfileView: (data) {
      final args = data.getArgs<CompanyProfileViewArguments>(
        orElse: () => const CompanyProfileViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i10.CompanyProfileView(key: args.key),
        settings: data,
      );
    },
    _i11.CvViewerView: (data) {
      final args = data.getArgs<CvViewerViewArguments>(nullOk: false);
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i11.CvViewerView(key: args.key, pdfPath: args.pdfPath),
        settings: data,
      );
    },
    _i12.RegisterView: (data) {
      final args = data.getArgs<RegisterViewArguments>(
        orElse: () => const RegisterViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.RegisterView(key: args.key),
        settings: data,
      );
    },
    _i13.ForgotPasswordView: (data) {
      final args = data.getArgs<ForgotPasswordViewArguments>(
        orElse: () => const ForgotPasswordViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i13.ForgotPasswordView(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class StudentMainViewArguments {
  const StudentMainViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StudentMainViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CompanyMainViewArguments {
  const CompanyMainViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CompanyMainViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class StudentDashboardViewArguments {
  const StudentDashboardViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StudentDashboardViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CompanyDashboardViewArguments {
  const CompanyDashboardViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CompanyDashboardViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class JobDetailViewArguments {
  const JobDetailViewArguments({this.key, required this.job});

  final _i14.Key? key;

  final JobListing job;

  @override
  String toString() {
    return '{"key": "$key", "job": "$job"}';
  }

  @override
  bool operator ==(covariant JobDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.job == job;
  }

  @override
  int get hashCode {
    return key.hashCode ^ job.hashCode;
  }
}

class AiJobGeneratorViewArguments {
  const AiJobGeneratorViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant AiJobGeneratorViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class StudentProfileViewArguments {
  const StudentProfileViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StudentProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CompanyProfileViewArguments {
  const CompanyProfileViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CompanyProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CvViewerViewArguments {
  const CvViewerViewArguments({this.key, required this.pdfPath});

  final _i14.Key? key;

  final String pdfPath;

  @override
  String toString() {
    return '{"key": "$key", "pdfPath": "$pdfPath"}';
  }

  @override
  bool operator ==(covariant CvViewerViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.pdfPath == pdfPath;
  }

  @override
  int get hashCode {
    return key.hashCode ^ pdfPath.hashCode;
  }
}

class RegisterViewArguments {
  const RegisterViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant RegisterViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ForgotPasswordViewArguments {
  const ForgotPasswordViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ForgotPasswordViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i15.NavigationService {
  Future<dynamic> navigateToLoginView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStudentMainView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.studentMainView,
      arguments: StudentMainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCompanyMainView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.companyMainView,
      arguments: CompanyMainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStudentDashboardView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.studentDashboardView,
      arguments: StudentDashboardViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCompanyDashboardView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.companyDashboardView,
      arguments: CompanyDashboardViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToJobDetailView({
    _i14.Key? key,
    required JobListing job,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.jobDetailView,
      arguments: JobDetailViewArguments(key: key, job: job),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAiJobGeneratorView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.aiJobGeneratorView,
      arguments: AiJobGeneratorViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStudentProfileView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.studentProfileView,
      arguments: StudentProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCompanyProfileView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.companyProfileView,
      arguments: CompanyProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCvViewerView({
    _i14.Key? key,
    required String pdfPath,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.cvViewerView,
      arguments: CvViewerViewArguments(key: key, pdfPath: pdfPath),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToRegisterView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.registerView,
      arguments: RegisterViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToForgotPasswordView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.forgotPasswordView,
      arguments: ForgotPasswordViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStudentMainView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.studentMainView,
      arguments: StudentMainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCompanyMainView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.companyMainView,
      arguments: CompanyMainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStudentDashboardView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.studentDashboardView,
      arguments: StudentDashboardViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCompanyDashboardView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.companyDashboardView,
      arguments: CompanyDashboardViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithJobDetailView({
    _i14.Key? key,
    required JobListing job,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.jobDetailView,
      arguments: JobDetailViewArguments(key: key, job: job),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAiJobGeneratorView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.aiJobGeneratorView,
      arguments: AiJobGeneratorViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStudentProfileView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.studentProfileView,
      arguments: StudentProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCompanyProfileView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.companyProfileView,
      arguments: CompanyProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCvViewerView({
    _i14.Key? key,
    required String pdfPath,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.cvViewerView,
      arguments: CvViewerViewArguments(key: key, pdfPath: pdfPath),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithRegisterView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.registerView,
      arguments: RegisterViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithForgotPasswordView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.forgotPasswordView,
      arguments: ForgotPasswordViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
