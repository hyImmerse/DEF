#!/bin/bash

echo "Fixing all remaining velocity_x patterns..."

# Find all dart files
find lib -name "*.dart" -type f | while read -r file; do
  # Create a temporary file
  temp_file="${file}.tmp"
  
  # Replace patterns
  sed -E \
    -e "s/'([^']+)'\.text\.size\(([0-9]+)\)\.make\(\)/Text('\1', style: TextStyle(fontSize: \2))/g" \
    -e "s/'([^']+)'\.text\.size\(([0-9]+)\)\.bold\.make\(\)/Text('\1', style: TextStyle(fontSize: \2, fontWeight: FontWeight.bold))/g" \
    -e "s/'([^']+)'\.text\.size\(([0-9]+)\)\.color\(([^)]+)\)\.make\(\)/Text('\1', style: TextStyle(fontSize: \2, color: \3))/g" \
    -e "s/'([^']+)'\.text\.size\(([0-9]+)\)\.bold\.color\(([^)]+)\)\.make\(\)/Text('\1', style: TextStyle(fontSize: \2, fontWeight: FontWeight.bold, color: \3))/g" \
    -e "s/'([^']+)'\.text\.color\(([^)]+)\)\.make\(\)/Text('\1', style: TextStyle(color: \2))/g" \
    -e "s/'([^']+)'\.text\.bold\.make\(\)/Text('\1', style: TextStyle(fontWeight: FontWeight.bold))/g" \
    -e "s/'([^']+)'\.text\.make\(\)/Text('\1')/g" \
    -e "s/'([^']+)'\.text/Text('\1')/g" \
    -e "s/\.text\.size\(([0-9]+)\)/, style: TextStyle(fontSize: \1))/g" \
    -e "s/\.text\.bold/, style: TextStyle(fontWeight: FontWeight.bold))/g" \
    -e "s/\.text\.gray([0-9]+)/, style: TextStyle(color: Colors.grey[\1]))/g" \
    -e "s/\.p\(([^)]+)\)/Padding(padding: EdgeInsets.all(\1), child: /g" \
    -e "s/\.px\(([^)]+)\)/Padding(padding: EdgeInsets.symmetric(horizontal: \1), child: /g" \
    -e "s/\.py\(([^)]+)\)/Padding(padding: EdgeInsets.symmetric(vertical: \1), child: /g" \
    -e "s/\.pOnly\(([^)]+)\)/Padding(padding: EdgeInsets.only(\1), child: /g" \
    -e "s/\.centered\(\)/Center(child: /g" \
    -e "s/\.center\(\)/Center(child: /g" \
    "$file" > "$temp_file"
  
  # Check if any changes were made
  if ! cmp -s "$file" "$temp_file"; then
    mv "$temp_file" "$file"
    echo "Fixed: $file"
  else
    rm "$temp_file"
  fi
done

echo "All velocity_x patterns fixed!"