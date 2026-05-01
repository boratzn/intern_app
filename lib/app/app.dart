import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../services/supabase_service.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/student_dashboard/student_dashboard_view.dart';
import '../ui/views/company_dashboard/company_dashboard_view.dart';
import '../ui/views/job_detail/job_detail_view.dart';
import '../ui/views/ai_job_generator/ai_job_generator_view.dart';
import '../ui/views/profile/student_profile/student_profile_view.dart';
import '../ui/views/profile/company_profile/company_profile_view.dart';
import '../ui/views/cv_viewer/cv_viewer_view.dart';
import '../ui/views/main/student_main/student_main_view.dart';
import '../ui/views/main/company_main/company_main_view.dart';
import '../ui/views/register/register_view.dart';
import '../ui/views/forgot_password/forgot_password_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView),
    MaterialRoute(page: StudentMainView),
    MaterialRoute(page: CompanyMainView),
    MaterialRoute(page: StudentDashboardView),
    MaterialRoute(page: CompanyDashboardView),
    MaterialRoute(page: JobDetailView),
    MaterialRoute(page: AiJobGeneratorView),
    MaterialRoute(page: StudentProfileView),
    MaterialRoute(page: CompanyProfileView),
    MaterialRoute(page: CvViewerView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: ForgotPasswordView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SupabaseService),
  ],
)
class App {}
