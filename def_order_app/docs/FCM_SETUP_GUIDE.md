# FCM 푸시 알림 설정 가이드

## 개요
이 문서는 DEF 주문 앱의 FCM(Firebase Cloud Messaging) 푸시 알림 설정 방법을 설명합니다.

## Firebase 프로젝트 설정

### 1. Firebase 콘솔에서 프로젝트 생성
1. [Firebase Console](https://console.firebase.google.com)에 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름 입력: "def-order-app"
4. Google Analytics 설정 (선택사항)

### 2. 앱 등록

#### Android 앱 등록
1. Firebase 콘솔에서 Android 아이콘 클릭
2. Android 패키지명 입력: `com.yourcompany.def_order_app`
3. `google-services.json` 다운로드
4. `android/app/` 디렉토리에 파일 복사

#### iOS 앱 등록
1. Firebase 콘솔에서 iOS 아이콘 클릭
2. iOS 번들 ID 입력: `com.yourcompany.defOrderApp`
3. `GoogleService-Info.plist` 다운로드
4. Xcode에서 `Runner` 폴더에 파일 추가

## Android 설정

### 1. build.gradle 설정

**android/build.gradle**:
```gradle
buildscript {
    dependencies {
        // 다른 의존성들...
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**android/app/build.gradle**:
```gradle
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services'  // 추가

android {
    defaultConfig {
        minSdkVersion 21  // FCM 최소 요구사항
    }
}
```

### 2. AndroidManifest.xml 설정

**android/app/src/main/AndroidManifest.xml**:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 인터넷 권한 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application>
        <!-- FCM 기본 알림 채널 -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="order_channel"/>
            
        <!-- FCM 기본 아이콘 -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher"/>
            
        <!-- FCM 기본 색상 -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/colorPrimary"/>
    </application>
</manifest>
```

## iOS 설정

### 1. Xcode 설정
1. Xcode에서 프로젝트 열기
2. `Runner` → `Signing & Capabilities` 탭
3. "+ Capability" 클릭
4. "Push Notifications" 추가
5. "Background Modes" 추가하고 다음 옵션 체크:
   - Remote notifications
   - Background fetch

### 2. Info.plist 설정

**ios/Runner/Info.plist**:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>FirebaseMessagingAutoInitEnabled</key>
<true/>
```

### 3. AppDelegate.swift 설정

**ios/Runner/AppDelegate.swift**:
```swift
import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // FCM 설정
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    
    application.registerForRemoteNotifications()
    
    // FCM 토큰 갱신 모니터링
    Messaging.messaging().delegate = self
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// FCM 토큰 갱신 처리
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("FCM 토큰: \(String(describing: fcmToken))")
  }
}
```

### 4. APNs 인증서 설정
1. [Apple Developer Console](https://developer.apple.com)에서 APNs 인증서 생성
2. Firebase 콘솔 → 프로젝트 설정 → 클라우드 메시징
3. iOS 앱 구성에서 APNs 인증서 업로드

## Supabase Edge Function 환경변수 설정

Supabase Dashboard에서 다음 환경변수를 설정:

```bash
FCM_SERVER_KEY=your_fcm_server_key_here
```

FCM 서버 키는 Firebase 콘솔 → 프로젝트 설정 → 클라우드 메시징에서 확인 가능

## 테스트

### 1. FCM 토큰 확인
```dart
// main.dart에서
final fcmToken = await FCMService.instance.fcmToken;
print('FCM 토큰: $fcmToken');
```

### 2. 테스트 알림 발송
Firebase 콘솔 → Cloud Messaging → 새 알림에서 테스트 메시지 발송

### 3. Supabase Edge Function 테스트
```bash
# Edge Function 배포
supabase functions deploy send-push-notification

# 테스트 호출
curl -X POST https://your-project.supabase.co/functions/v1/send-push-notification \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test-user-id",
    "notification": {
      "title": "테스트 알림",
      "body": "푸시 알림 테스트입니다."
    }
  }'
```

## 주의사항

1. **iOS 실제 기기 테스트**: iOS 시뮬레이터에서는 푸시 알림이 작동하지 않음
2. **Android 에뮬레이터**: Google Play Services가 설치된 에뮬레이터 사용
3. **백그라운드 제한**: 앱이 강제 종료된 상태에서는 일부 기기에서 알림이 도착하지 않을 수 있음
4. **배터리 최적화**: 일부 Android 기기에서는 배터리 최적화로 인해 알림이 지연될 수 있음

## 문제 해결

### FCM 토큰을 받지 못하는 경우
1. 인터넷 연결 확인
2. Google Play Services(Android) 또는 APNs(iOS) 연결 확인
3. Firebase 프로젝트 설정 확인

### 알림이 표시되지 않는 경우
1. 앱 알림 권한 확인
2. 알림 채널 설정 확인 (Android)
3. 포그라운드/백그라운드 상태별 처리 확인

### iOS에서 알림이 작동하지 않는 경우
1. APNs 인증서 유효성 확인
2. Provisioning Profile에 Push Notification 권한 포함 확인
3. 실제 기기에서 테스트

## 참고 자료
- [Firebase Cloud Messaging 문서](https://firebase.google.com/docs/cloud-messaging)
- [flutter_local_notifications 패키지](https://pub.dev/packages/flutter_local_notifications)
- [firebase_messaging 패키지](https://pub.dev/packages/firebase_messaging)