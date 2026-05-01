import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'applied_jobs_viewmodel.dart';
import '../../../core/enums/application_status.dart';

class AppliedJobsView extends StackedView<AppliedJobsViewModel> {
  const AppliedJobsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    AppliedJobsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Başvurularım',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: viewModel.isBusy
          ? _buildShimmerLoading()
          : viewModel.appliedJobs.isEmpty
          ? _buildEmptyState()
          : _buildJobsList(viewModel),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_rounded,
              size: 64,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Henüz bir ilana\nbaşvurmadınız',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'İlgilendiğiniz ilanlara başvuru yaparak\nsürecinizi buradan takip edebilirsiniz.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ).animate().fade().scale(duration: 400.ms, delay: 100.ms),
    );
  }

  Widget _buildJobsList(AppliedJobsViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: viewModel.appliedJobs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final job = viewModel.appliedJobs[index];
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => viewModel.navigateToTracker(job),
          child: _buildJobCard(job, index),
        );
      },
    );
  }

  Widget _buildJobCard(Map<String, dynamic> application, int index) {
    final job = application['job_listings'];
    if (job == null) return const SizedBox.shrink();
    
    final company = job['company_profiles'];
    final status = application['status'] ?? 'pending';
    final appliedAt = application['applied_at'] != null 
        ? DateTime.parse(application['applied_at'])
        : null;

    final appStatus = ApplicationStatus.fromString(status.toString());
    final statusColor = appStatus.color;
    final statusText = appStatus.label;
    // Map basic icons to the 8 statuses based on emoji/concept or just use an icon
    IconData statusIcon = Icons.info_outline;
    if (appStatus == ApplicationStatus.hired) {
      statusIcon = Icons.check_circle_rounded;
    } else if (appStatus == ApplicationStatus.rejected || appStatus == ApplicationStatus.withdrawn) {
      statusIcon = Icons.cancel_rounded;
    } else if (appStatus == ApplicationStatus.interview) {
      statusIcon = Icons.video_camera_front;
    } else {
      statusIcon = Icons.access_time_filled_rounded;
    }

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: company?['logo_url'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              company['logo_url'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.apartment,
                            color: Color(0xFF6B7280),
                            size: 28,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'] ?? 'İlan Başlığı',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company?['company_name'] ?? 'Bilinmeyen Şirket',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF4B5563),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (appliedAt != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Başvuru: ${DateFormat('dd.MM.yyyy').format(appliedAt)}',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF3F4F6)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    children: [
                      if (job['location'] != null && job['location'].toString().isNotEmpty)
                        _buildTagsLine(Icons.location_on_outlined, job['location']),
                      if (job['work_type'] != null && job['work_type'].toString().isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _buildTagsLine(Icons.work_outline_rounded, job['work_type']),
                      ],
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withAlpha(50)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 400.ms, delay: (index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildTagsLine(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6B7280)),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  @override
  void onViewModelReady(AppliedJobsViewModel viewModel) {
    viewModel.init();
  }

  @override
  AppliedJobsViewModel viewModelBuilder(BuildContext context) =>
      AppliedJobsViewModel();
}
