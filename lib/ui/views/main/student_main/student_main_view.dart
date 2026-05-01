import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../student_dashboard/student_dashboard_view.dart';
import '../../applied_jobs/applied_jobs_view.dart';
import '../../saved_jobs/saved_jobs_view.dart';
import '../../profile/student_profile/student_profile_view.dart';
import 'student_main_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentMainView extends StackedView<StudentMainViewModel> {
  const StudentMainView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StudentMainViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: getViewForIndex(viewModel.currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.setIndex,
          selectedItemColor: const Color(0xFF4F46E5),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Keşfet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send_outlined),
              activeIcon: Icon(Icons.send_rounded),
              label: 'Başvurularım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              activeIcon: Icon(Icons.bookmark),
              label: 'Kaydedilenler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const StudentDashboardView();
      case 1:
        return const AppliedJobsView();
      case 2:
        return const SavedJobsView();
      case 3:
        return const StudentProfileView();
      default:
        return const StudentDashboardView();
    }
  }

  @override
  StudentMainViewModel viewModelBuilder(BuildContext context) =>
      StudentMainViewModel();

  @override
  void onViewModelReady(StudentMainViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
