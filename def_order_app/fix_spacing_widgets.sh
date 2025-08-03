#!/bin/bash

echo "Fixing AppSpacing widget usage..."

# Fix vertical spacing in order_history_card.dart
sed -i 's/AppSpacing\.v4,/const SizedBox(height: AppSpacing.v4),/g' lib/features/history/presentation/widgets/order_history_card.dart
sed -i 's/AppSpacing\.v8,/const SizedBox(height: AppSpacing.v8),/g' lib/features/history/presentation/widgets/order_history_card.dart
sed -i 's/AppSpacing\.v16,/const SizedBox(height: AppSpacing.v16),/g' lib/features/history/presentation/widgets/order_history_card.dart

# Fix horizontal spacing in order_history_card.dart  
sed -i 's/AppSpacing\.h8,/const SizedBox(width: AppSpacing.h8),/g' lib/features/history/presentation/widgets/order_history_card.dart
sed -i 's/AppSpacing\.h12,/const SizedBox(width: AppSpacing.h12),/g' lib/features/history/presentation/widgets/order_history_card.dart

# Fix spacing in order_history_filter.dart
sed -i 's/AppSpacing\.h12,/const SizedBox(width: AppSpacing.h12),/g' lib/features/history/presentation/widgets/order_history_filter.dart
sed -i 's/AppSpacing\.h8,/const SizedBox(width: AppSpacing.h8),/g' lib/features/history/presentation/widgets/order_history_filter.dart
sed -i 's/AppSpacing\.v8,/const SizedBox(height: AppSpacing.v8),/g' lib/features/history/presentation/widgets/order_history_filter.dart
sed -i 's/AppSpacing\.v20,/const SizedBox(height: AppSpacing.v20),/g' lib/features/history/presentation/widgets/order_history_filter.dart
sed -i 's/AppSpacing\.v24,/const SizedBox(height: AppSpacing.v24),/g' lib/features/history/presentation/widgets/order_history_filter.dart

# Fix spacing in order_statistics_card.dart
sed -i 's/AppSpacing\.v16,/const SizedBox(height: AppSpacing.v16),/g' lib/features/history/presentation/widgets/order_statistics_card.dart
sed -i 's/AppSpacing\.v24,/const SizedBox(height: AppSpacing.v24),/g' lib/features/history/presentation/widgets/order_statistics_card.dart

# Fix spacing in order_detail_screen.dart
sed -i 's/AppSpacing\.v16,/const SizedBox(height: AppSpacing.v16),/g' lib/features/order/presentation/screens/order_detail_screen.dart

# Fix spacing in order_creation_screen.dart
sed -i 's/AppSpacing\.v16,/const SizedBox(height: AppSpacing.v16),/g' lib/features/order/presentation/screens/order_creation_screen.dart
sed -i 's/AppSpacing\.v24,/const SizedBox(height: AppSpacing.v24),/g' lib/features/order/presentation/screens/order_creation_screen.dart

# Fix h6 reference - replace with h8
sed -i 's/AppSpacing\.h6/AppSpacing.h8/g' lib/features/history/presentation/widgets/order_history_card.dart

echo "Fixing widget usages complete!"