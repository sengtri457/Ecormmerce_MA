import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../widgets/app_button.dart';

class BagOrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final double total;
  final int selectedCount;
  final VoidCallback onCheckout;

  const BagOrderSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.discountAmount,
    required this.total,
    required this.selectedCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _priceRow('Sub-Total', subtotal.toCurrency()),
        const SizedBox(height: 10),
        _priceRow('Delivery Fee', shippingFee.toCurrency()),
        const SizedBox(height: 10),
        _priceRow(
          'Discount',
          discountAmount.toDiscountCurrency(),
          isDiscount: true,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Divider(color: AppColors.border, height: 1),
        ),
        _priceRow('Total Cost', total.toCurrency(), isTotal: true),
        const SizedBox(height: 28),
        AppButton(
          text: selectedCount > 0
              ? 'PROCEED TO CHECKOUT • ${total.toCurrency()}'
              : 'SELECT ITEMS TO CHECKOUT',
          variant: selectedCount > 0
              ? AppButtonVariant.primary
              : AppButtonVariant.secondary,
          onPressed: selectedCount > 0
              ? onCheckout
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one item to proceed.'),
                      backgroundColor: AppColors.black,
                    ),
                  );
                },
        ),
      ],
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.headingSmall.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )
              : AppTypography.bodySmall.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.headingSmall.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                )
              : AppTypography.bodySmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? AppColors.alertRed : AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
