#!/bin/bash

# VelocityX imports 제거
find ../lib -name "*.dart" -type f -exec sed -i "s/import 'package:velocity_x\/velocity_x.dart';//g" {} +

# VelocityX 사용 패턴 제거 및 대체
# .heightBox -> const SizedBox(height: )
find ../lib -name "*.dart" -type f -exec sed -i -E 's/([0-9]+)\.heightBox/const SizedBox(height: \1)/g' {} +

# .widthBox -> const SizedBox(width: )
find ../lib -name "*.dart" -type f -exec sed -i -E 's/([0-9]+)\.widthBox/const SizedBox(width: \1)/g' {} +

# .text.make() -> Text() 변환은 복잡하므로 수동으로 처리

echo "VelocityX imports와 기본 패턴들이 제거되었습니다."
echo "복잡한 .text 체인은 수동으로 수정이 필요합니다."