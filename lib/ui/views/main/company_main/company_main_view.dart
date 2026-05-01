import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../company_dashboard/company_dashboard_view.dart';
import '../../create_job/create_job_view.dart';
import '../../my_jobs/my_jobs_view.dart';
import '../../profile/company_profile/company_profile_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'company_main_viewmodel.dart';

class CompanyMainView extends StackedView<CompanyMainViewModel> {
  const CompanyMainView({super.key});

  @override
  Widget builder(
    BuildContext context,
    CompanyMainViewModel viewModel,
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
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded),
              activeIcon: Icon(Icons.work_rounded),
              label: 'İlanlarım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: 'İlan Oluştur',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined),
              activeIcon: Icon(Icons.business),
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
        return const CompanyDashboardView();
      case 1:
        return const MyJobsView();
      case 2:
        return const CreateJobView();
      case 3:
        return const CompanyProfileView();
      default:
        return const CompanyDashboardView();
    }
  }

  @override
  CompanyMainViewModel viewModelBuilder(BuildContext context) =>
      CompanyMainViewModel();

  @override
  void onViewModelReady(CompanyMainViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
