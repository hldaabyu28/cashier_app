import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosRecipesPage extends GetView<PosController> {
  const PosRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch transactions when page is viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.transactionHistory.isEmpty) {
        controller.fetchTransactions();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Transaction History',
                      style: AppTextStyle.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.fetchTransactions(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Transaction list
            Expanded(
              child: Obx(() {
                if (controller.isTransactionLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  );
                }

                if (controller.transactionHistory.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 80, color: Colors.grey[200]),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: AppTextStyle.heading3
                              .copyWith(color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your completed orders will appear here',
                          style: AppTextStyle.caption
                              .copyWith(color: Colors.grey[300]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextButton.icon(
                          onPressed: () => controller.fetchTransactions(),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Refresh'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchTransactions(),
                  color: AppColor.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.transactionHistory.length,
                    itemBuilder: (context, index) {
                      final trx = controller.transactionHistory[index];
                      return _TransactionCard(transaction: trx);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final orderId = transaction['orderId'] ?? transaction['_id'] ?? '-';
    final customer = transaction['customer'] ?? 'Unknown';
    final status = transaction['status'] ?? 'pending';
    final total = (transaction['total'] ?? 0).toDouble();
    final paymentType = transaction['paymentType'] ?? 'cash';
    final createdAt = transaction['createdAt'] ?? '';

    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID + Status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  orderId.toString(),
                  style: AppTextStyle.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status.toString().toUpperCase(),
                      style: AppTextStyle.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Customer + Payment
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 16, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text(
                customer.toString(),
                style: AppTextStyle.subtitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      paymentType == 'midtrans'
                          ? Icons.credit_card_rounded
                          : Icons.payments_outlined,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      paymentType.toString().capitalize!,
                      style: AppTextStyle.caption.copyWith(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${_fmt(total.toInt())}',
                style: AppTextStyle.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              if (createdAt.isNotEmpty)
                Text(
                  _formatDate(createdAt.toString()),
                  style: AppTextStyle.caption.copyWith(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'success':
        return Icons.check_circle_outline_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'failed':
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}
