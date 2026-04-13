import 'package:casier_app/core/theme/app_color.dart';
import 'package:casier_app/core/theme/app_text.dart';
import 'package:casier_app/core/services/discount_service.dart';
import 'package:casier_app/core/services/tax_service.dart';
import 'package:casier_app/features/pos/presentation/controllers/pos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PosCheckoutPage extends StatefulWidget {
  const PosCheckoutPage({super.key});

  @override
  State<PosCheckoutPage> createState() => _PosCheckoutPageState();
}

class _PosCheckoutPageState extends State<PosCheckoutPage> {
  final PosController controller = Get.find<PosController>();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  String _selectedPayment = 'cash';
  String? _selectedTaxId;

  List<dynamic> _taxes = [];
  bool _isLoadingTaxes = true;

  // Discount validation state
  Map<String, dynamic>? _validatedDiscount;
  bool _isCheckingDiscount = false;

  @override
  void initState() {
    super.initState();
    _loadTaxes();
  }

  Future<void> _loadTaxes() async {
    final taxes = await TaxService.to.getTaxes();
    if (mounted) {
      setState(() {
        _taxes = taxes ?? [];
        _isLoadingTaxes = false;
      });
    }
  }

  Future<void> _validateDiscount() async {
    final code = discountController.text.trim();
    if (code.isEmpty) {
      setState(() => _validatedDiscount = null);
      return;
    }

    setState(() => _isCheckingDiscount = true);

    final result = await DiscountService.to.checkDiscountCode(code);
    if (mounted) {
      setState(() {
        _validatedDiscount = result;
        _isCheckingDiscount = false;
      });

      if (result != null) {
        Get.snackbar('Discount Applied', 'Code "$code" is valid!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Invalid Code', 'Discount code "$code" is not valid.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> _processCheckout() async {
    final customerName = customerController.text.trim();

    if (customerName.isEmpty) {
      Get.snackbar('Required', 'Please enter a customer name',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final result = await controller.checkout(
      customerName: customerName,
      paymentType: _selectedPayment,
      discountCode: discountController.text.trim().isNotEmpty
          ? discountController.text.trim()
          : null,
      taxId: _selectedTaxId,
    );

    if (result != null) {
      // If midtrans payment, open snap URL
      if (_selectedPayment == 'midtrans' && result['snapUrl'] != null) {
        final url = Uri.parse(result['snapUrl']);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        // Switch to home tab
        controller.selectedTab.value = 0;
      }
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColor.primary),
        ),
        title: Text(
          'Checkout',
          style: AppTextStyle.heading3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Summary ──────────────────────────────────────
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 10),
            _buildOrderSummaryCard(),

            const SizedBox(height: 24),

            // ── Customer Name ──────────────────────────────────────
            _buildSectionTitle('Customer Name'),
            const SizedBox(height: 10),
            _buildInputField(
              controller: customerController,
              hint: 'Enter customer name',
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: 24),

            // ── Payment Method ─────────────────────────────────────
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 10),
            _buildPaymentMethodSelector(),

            const SizedBox(height: 24),

            // ── Discount Code ──────────────────────────────────────
            _buildSectionTitle('Discount Code (Optional)'),
            const SizedBox(height: 10),
            _buildDiscountInput(),

            const SizedBox(height: 24),

            // ── Tax ────────────────────────────────────────────────
            _buildSectionTitle('Tax (Optional)'),
            const SizedBox(height: 10),
            _buildTaxSelector(),

            const SizedBox(height: 32),

            // ── Checkout Button ────────────────────────────────────
            _buildCheckoutButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.subtitle.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColor.primary,
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
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
          children: [
            ...controller.cartItems.map((product) {
              final qty = controller.quantities[product.id] ?? 0;
              final subtotal = product.price * qty;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image,
                              size: 18, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: AppTextStyle.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'x$qty',
                            style: AppTextStyle.caption
                                .copyWith(color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${_fmt(subtotal.toInt())}',
                      style: AppTextStyle.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${controller.cartCount.value} items)',
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Rp ${_fmt(controller.cartTotal.value.toInt())}',
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyle.subtitle,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColor.primary, size: 20),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyle.subtitle.copyWith(color: Colors.grey[400]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPaymentOption(
            label: 'Cash',
            icon: Icons.payments_outlined,
            value: 'cash',
          ),
          const SizedBox(width: 8),
          _buildPaymentOption(
            label: 'Midtrans',
            icon: Icons.credit_card_rounded,
            value: 'midtrans',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _selectedPayment == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPayment = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primary
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColor.secondary : Colors.grey[500],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyle.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColor.secondary : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: discountController,
              style: AppTextStyle.subtitle,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.local_offer_outlined,
                    color: AppColor.primary, size: 20),
                border: InputBorder.none,
                hintText: 'Enter discount code',
                hintStyle:
                    AppTextStyle.subtitle.copyWith(color: Colors.grey[400]),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _isCheckingDiscount
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton(
                    onPressed: _validateDiscount,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.secondary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    child: Text(
                      'Apply',
                      style: AppTextStyle.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxSelector() {
    if (_isLoadingTaxes) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_taxes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.grey[400], size: 18),
            const SizedBox(width: 10),
            Text(
              'No taxes available',
              style: AppTextStyle.caption.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selectedTaxId,
          isExpanded: true,
          hint: Text(
            'Select tax (optional)',
            style: AppTextStyle.subtitle.copyWith(color: Colors.grey[400]),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColor.primary),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('No tax',
                  style: AppTextStyle.subtitle
                      .copyWith(color: Colors.grey[500])),
            ),
            ..._taxes.map((tax) {
              return DropdownMenuItem<String?>(
                value: tax['_id']?.toString(),
                child: Text(
                  '${tax['name']} (${tax['percentage']}%)',
                  style: AppTextStyle.subtitle,
                ),
              );
            }),
          ],
          onChanged: (value) {
            setState(() => _selectedTaxId = value);
          },
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Obx(() {
      final isLoading = controller.isCheckoutLoading.value;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : _processCheckout,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.secondary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
            disabledBackgroundColor: AppColor.primary.withOpacity(0.5),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.secondary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedPayment == 'cash'
                          ? Icons.payments_outlined
                          : Icons.credit_card_rounded,
                      size: 20,
                      color: AppColor.secondary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedPayment == 'cash'
                          ? 'Pay with Cash'
                          : 'Pay with Midtrans',
                      style: AppTextStyle.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondary,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
