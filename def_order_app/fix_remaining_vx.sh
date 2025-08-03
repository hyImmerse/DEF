#!/bin/bash

echo "Fixing remaining velocity_x patterns..."

# Navigate to the lib directory
cd lib

# Fix simple .make() patterns
find . -name "*.dart" -exec sed -i "s/\.make(),/),/g" {} \;

# Fix common color patterns
find . -name "*.dart" -exec sed -i "s/\.gray500/color: Colors.grey/g" {} \;
find . -name "*.dart" -exec sed -i "s/\.gray600/color: Colors.grey[600]/g" {} \;
find . -name "*.dart" -exec sed -i "s/\.gray700/color: Colors.grey[700]/g" {} \;

# Fix .bold patterns
find . -name "*.dart" -exec sed -i "s/\.bold\./fontWeight: FontWeight.bold, /g" {} \;

# Fix remaining .size() patterns
find . -name "*.dart" -exec sed -i "s/\.size(\([0-9]\+\))\./fontSize: \1, /g" {} \;

echo "Basic patterns fixed. Manual review needed for complex chained patterns."
echo "Run 'flutter analyze' to check for remaining issues."