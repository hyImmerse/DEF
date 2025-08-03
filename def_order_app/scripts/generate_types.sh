#!/bin/bash

# Generate Supabase types
echo "Generating Supabase types..."

# Run code generation for freezed and json_serializable
fvm flutter pub run build_runner build --delete-conflicting-outputs

echo "Type generation completed!"