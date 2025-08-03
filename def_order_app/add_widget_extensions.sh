#!/bin/bash

echo "Adding widget_extensions import to files with velocity_x patterns..."

# Files that use velocity_x patterns
files=(
  "lib/features/order/presentation/screens/order_list_screen.dart"
  "lib/features/order/presentation/screens/order_detail_screen.dart"
  "lib/features/order/presentation/screens/order_creation_screen.dart"
  "lib/features/order/presentation/screens/order_edit_screen.dart"
  "lib/features/order/presentation/widgets/order_card_widget.dart"
  "lib/features/order/presentation/widgets/order_filter_widget.dart"
  "lib/features/order/presentation/widgets/order_stats_widget.dart"
  "lib/features/auth/presentation/screens/admin_approval_waiting_screen.dart"
  "lib/features/auth/presentation/screens/login_screen_v2.dart"
  "lib/features/auth/presentation/widgets/business_number_input.dart"
  "lib/features/history/presentation/widgets/order_history_card.dart"
  "lib/features/history/presentation/widgets/order_history_filter.dart"
  "lib/features/history/presentation/widgets/order_statistics_card.dart"
  "lib/features/history/presentation/screens/transaction_statement_viewer.dart"
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    # Check if widget_extensions is already imported
    if ! grep -q "widget_extensions.dart" "$file"; then
      # Add import after the first package import
      sed -i "/^import 'package:flutter\/material.dart';/a import '../../../../core/utils/widget_extensions.dart';" "$file" 2>/dev/null || \
      sed -i "/^import 'package:flutter\/material.dart';/a import '../../../core/utils/widget_extensions.dart';" "$file" 2>/dev/null || \
      sed -i "/^import 'package:flutter\/material.dart';/a import '../../core/utils/widget_extensions.dart';" "$file" 2>/dev/null
      
      echo "Added import to: $file"
    fi
  fi
done

echo "Import additions complete!"