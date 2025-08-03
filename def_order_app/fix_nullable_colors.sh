#!/bin/bash

echo "Fixing nullable color issues..."

# Fix order_filter_widget.dart
sed -i 's/Colors\.grey\[500\]/Colors.grey[500]!/g' lib/features/order/presentation/widgets/order_filter_widget.dart
sed -i 's/Colors\.grey\[600\]/Colors.grey[600]!/g' lib/features/order/presentation/widgets/order_filter_widget.dart  
sed -i 's/Colors\.grey\[700\]/Colors.grey[700]!/g' lib/features/order/presentation/widgets/order_filter_widget.dart

# Fix order_detail_screen.dart
sed -i 's/Colors\.grey\[600\]/Colors.grey[600]!/g' lib/features/order/presentation/screens/order_detail_screen.dart

# Fix order_creation_screen.dart  
sed -i 's/Colors\.grey\[700\]/Colors.grey[700]!/g' lib/features/order/presentation/screens/order_creation_screen.dart
sed -i 's/Colors\.grey\[600\]/Colors.grey[600]!/g' lib/features/order/presentation/screens/order_creation_screen.dart

echo "Nullable color fixes complete!"