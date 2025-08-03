#!/bin/bash

echo "Fixing remaining AppSpacing widget usage..."

# Define all vertical spacing values
for i in 4 8 12 16 20 24 32 40 48; do
  echo "Fixing v$i..."
  find lib/ -name "*.dart" -exec sed -i "s/AppSpacing\.v$i,/const SizedBox(height: AppSpacing.v$i),/g" {} \;
done

# Define all horizontal spacing values  
for i in 4 6 8 12 16 20 24 32; do
  echo "Fixing h$i..."
  find lib/ -name "*.dart" -exec sed -i "s/AppSpacing\.h$i,/const SizedBox(width: AppSpacing.h$i),/g" {} \;
done

echo "Fixing remaining spacing complete!"