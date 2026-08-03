import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/report.dart';
import '../../providers/report_providers.dart';

class UploadReportsScreen extends ConsumerStatefulWidget {
  const UploadReportsScreen({super.key});

  @override
  ConsumerState<UploadReportsScreen> createState() =>
      _UploadReportsScreenState();
}

class _UploadReportsScreenState extends ConsumerState<UploadReportsScreen> {
  String? _selectedFileName;
  String? _selectedFileSize;
  String? _selectedFileType;

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (bytes / 1024).floor();
    return "${(bytes / (i > 0 ? (1024 * i) : 1)).toStringAsFixed(1)} ${suffixes[i]}";
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return 'Recent';
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase().replaceAll('.', '')) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'zip':
        return Icons.archive_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase().replaceAll('.', '')) {
      case 'pdf':
        return Colors.red.shade400;
      case 'zip':
        return Colors.amber.shade700;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppColors.primaryGreen;
      default:
        return AppColors.secondaryText;
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'zip', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final platformFile = result.files.single;
        final file = File(platformFile.path!);

        setState(() {
          _selectedFileName = platformFile.name;
          _selectedFileSize = _formatBytes(platformFile.size);
          _selectedFileType = platformFile.extension;
        });

        await ref.read(reportUploadNotifierProvider.notifier).uploadFile(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsState = ref.watch(reportsListProvider);
    final uploadState = ref.watch(reportUploadNotifierProvider);
    final uploadProgress = ref.watch(uploadProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Medical Reports',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(reportsListProvider.future),
        color: AppColors.primaryGreen,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Health Files',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Upload doctor notes, lab reports, or skincare prescriptions. Supported: PDF, ZIP, PNG, JPG (Max 5MB).',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildUploadTriggerCard(uploadState.isLoading),
                    if (uploadState.isLoading ||
                        uploadState.hasValue ||
                        uploadState.hasError) ...[
                      const SizedBox(height: 20),
                      _buildUploadProgressCard(uploadState, uploadProgress),
                    ],
                    const SizedBox(height: 32),
                    Text(
                      'Previous Uploads',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            reportsState.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              size: 48,
                              color: AppColors.secondaryText,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No reports uploaded yet',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final report = reports[index];
                        return _buildReportItemCard(report);
                      },
                      childCount: reports.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                ),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 40, color: AppColors.error),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load reports history',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(reportsListProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTriggerCard(bool isLoading) {
    return InkWell(
      onTap: isLoading ? null : _pickAndUploadFile,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen.withValues(alpha: 0.2),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 32,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select file to upload',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PDF, ZIP, PNG, or JPG (up to 5MB)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadProgressCard(AsyncValue<Report?> state, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warmBeige.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getFileIcon(_selectedFileType ?? ''),
                color: _getFileColor(_selectedFileType ?? ''),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFileName ?? 'Selected File',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedFileSize ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoading)
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              if (state.hasError)
                const Icon(Icons.error_outline, color: AppColors.error)
              else if (state.hasValue && state.value != null)
                const Icon(Icons.check_circle_outline,
                    color: AppColors.primaryGreen),
            ],
          ),
          const SizedBox(height: 12),
          if (state.isLoading)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGreen,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              borderRadius: BorderRadius.circular(4),
            )
          else if (state.hasError)
            Text(
              'Upload failed: ${state.error}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            )
          else if (state.hasValue && state.value != null)
            Text(
              'Successfully synced with your profile!',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReportItemCard(Report report) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.warmBeige.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getFileColor(report.fileType).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getFileIcon(report.fileType),
                color: _getFileColor(report.fileType),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.filename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatBytes(report.fileSize),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryText,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(report.uploadedAt),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
