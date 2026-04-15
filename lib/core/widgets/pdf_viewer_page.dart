import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import 'download_confirm_dialog.dart';
import 'success_dialog.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  final String title;
  final String fileName;

  const PdfViewerPage({
    super.key,
    required this.url,
    required this.title,
    required this.fileName,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool _isDownloading = false;
  double _downloadProgress = 0;

  Future<void> _startDownload() async {
    try {
      // Check permissions
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            // For Android 13+ we might need manageExternalStorage or just use app docs
            if (await Permission.manageExternalStorage.request().isDenied) {
              // If still denied, try to proceed with internal docs
            }
          }
        }
      }

      setState(() {
        _isDownloading = true;
        _downloadProgress = 0;
      });

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = "${directory!.path}/${widget.fileName}";
      final dio = Dio();

      await dio.download(
        widget.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        _isDownloading = false;
      });

      if (mounted) {
        SuccessDialog.show(
          context,
          title: 'Download Success',
          message: 'Your payslip has been successfully downloaded.',
        );
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDownloadConfirm() {
    DownloadConfirmDialog.show(
      context,
      onConfirm: _startDownload,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isDownloading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: _downloadProgress,
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.textPrimary,
                    size: 28,
                  ),
                  onPressed: _showDownloadConfirm,
                ),
        ],
        shape: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
      ),
      body: SfPdfViewer.network(widget.url),
    );
  }
}
