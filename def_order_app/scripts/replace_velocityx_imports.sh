#!/bin/bash

# VelocityX import를 호환성 레이어로 대체
find ../lib -name "*.dart" -type f | while read file; do
  # 파일이 velocity_x_compat.dart 자체가 아닌 경우에만 처리
  if [[ ! "$file" =~ "velocity_x_compat.dart" ]]; then
    # VelocityX import가 있는지 확인
    if grep -q "import 'package:velocity_x/velocity_x.dart';" "$file"; then
      # 상대 경로 계산
      depth=$(echo "$file" | awk -F'/' '{print NF-4}')
      relative_path=""
      for ((i=0; i<$depth; i++)); do
        relative_path="../$relative_path"
      done
      relative_path="${relative_path}core/utils/velocity_x_compat.dart"
      
      # import 대체
      sed -i "s|import 'package:velocity_x/velocity_x.dart';|import '$relative_path'; // VelocityX 호환성 레이어|g" "$file"
      echo "Updated: $file"
    fi
  fi
done

echo "모든 VelocityX imports가 호환성 레이어로 대체되었습니다."