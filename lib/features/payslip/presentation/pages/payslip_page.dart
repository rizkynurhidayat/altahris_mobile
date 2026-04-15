import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/pdf_viewer_page.dart';

class PayslipPage extends StatefulWidget {
  const PayslipPage({super.key});

  @override
  State<PayslipPage> createState() => _PayslipPageState();
}

class _PayslipPageState extends State<PayslipPage> {
  final List<Map<String, String>> _payslips = [
    {
      'month': 'April 2026',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'status': 'On Process',
      'paidOn': '-',
    },
    {
      'month': 'March 2026',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'status': 'Paid',
      'paidOn': '25 Mar 2026',
    },
    {
      'month': 'February 2026',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'status': 'Paid',
      'paidOn': '25 Feb 2026',
    },
    {
      'month': 'January 2026',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'status': 'Paid',
      'paidOn': '25 Jan 2026',
    },
    {
      'month': 'Desember 2025',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'status': 'Paid',
      'paidOn': '25 Des 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          'Payslip',
          style: TextStyle(
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
        shape: Border(
          bottom: BorderSide(color: Colors.grey[100]!, width: 1),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _payslips.length,
        itemBuilder: (context, index) {
          final payslip = _payslips[index];
          final month = payslip['month']!;
          final url = payslip['url']!;
          final status = payslip['status']!;
          final paidOn = payslip['paidOn']!;
          final isPaid = status == 'Paid';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Text(
                    month,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[100]),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Status:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusBadge(status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  'Paid on:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  paidOn,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: isPaid
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PdfViewerPage(
                                        url: url,
                                        title: 'Payslip Detail',
                                        fileName: "Payslip_${month.replaceAll(' ', '_')}.pdf",
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: const Color(0xFF9E9E9E),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: const Text(
                            'View Payslip',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    if (status == 'Paid') {
      backgroundColor = const Color(0xFFE8F8EF);
      textColor = const Color(0xFF2ECC71);
    } else {
      backgroundColor = const Color(0xFFE3F2FD);
      textColor = const Color(0xFF2196F3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
