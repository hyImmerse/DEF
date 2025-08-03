#!/usr/bin/env python3
"""
Script to replace remaining velocity_x syntax with standard Flutter widgets
"""

import os
import re
import glob

def fix_velocity_x_patterns(content):
    """Replace velocity_x patterns with standard Flutter equivalents"""
    
    # Simple text patterns
    content = re.sub(r"'([^']+)'\.text\.make\(\),", r"Text('\1'),", content)
    content = re.sub(r'"([^"]+)"\.text\.make\(\),', r'Text("\1"),', content)
    
    # Text with size only
    content = re.sub(r"'([^']+)'\.text\.size\((\d+)\)\.make\(\),", r"Text('\1', style: TextStyle(fontSize: \2)),", content)
    content = re.sub(r'"([^"]+)"\.text\.size\((\d+)\)\.make\(\),', r'Text("\1", style: TextStyle(fontSize: \2)),', content)
    
    # Text with bold only
    content = re.sub(r"'([^']+)'\.text\.bold\.make\(\),", r"Text('\1', style: TextStyle(fontWeight: FontWeight.bold)),", content)
    content = re.sub(r'"([^"]+)"\.text\.bold\.make\(\),', r'Text("\1", style: TextStyle(fontWeight: FontWeight.bold)),', content)
    
    # Text with size and bold
    content = re.sub(r"'([^']+)'\.text\.size\((\d+)\)\.bold\.make\(\),", r"Text('\1', style: TextStyle(fontSize: \2, fontWeight: FontWeight.bold)),", content)
    content = re.sub(r'"([^"]+)"\.text\.size\((\d+)\)\.bold\.make\(\),', r'Text("\1", style: TextStyle(fontSize: \2, fontWeight: FontWeight.bold)),', content)
    
    # Common color patterns
    content = re.sub(r"\.gray500\.make\(\),", r", style: TextStyle(color: Colors.grey)),", content)
    content = re.sub(r"\.gray600\.make\(\),", r", style: TextStyle(color: Colors.grey[600])),", content)
    content = re.sub(r"\.gray700\.make\(\),", r", style: TextStyle(color: Colors.grey[700])),", content)
    
    # Replace .text. chains that span multiple lines - more complex patterns
    # This is a simplified approach - in practice, these need manual review
    content = re.sub(r"(\w+)\.text\s*\n\s*\.(\w+)\([^)]*\)\s*\n\s*\.make\(\),", 
                    r"Text(\1, style: TextStyle()),", content, flags=re.MULTILINE)
    
    return content

def process_dart_files():
    """Process all Dart files to remove velocity_x syntax"""
    
    # Find all Dart files
    dart_files = glob.glob("lib/**/*.dart", recursive=True)
    
    for file_path in dart_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Skip if no velocity_x patterns
            if not any(pattern in content for pattern in ['.text.', '.make()', '.heightBox', '.widthBox']):
                continue
                
            print(f"Processing: {file_path}")
            
            # Apply fixes
            original_content = content
            content = fix_velocity_x_patterns(content)
            
            # Write back if changed
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Updated: {file_path}")
                
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

def main():
    """Main function"""
    print("Starting velocity_x cleanup...")
    
    # Change to the Flutter project directory
    os.chdir("D:/mobile/SCR/def_order_app")
    
    # Process files
    process_dart_files()
    
    print("Cleanup completed. Please review and test the changes.")
    print("You may need to manually fix complex patterns that couldn't be automatically replaced.")

if __name__ == "__main__":
    main()