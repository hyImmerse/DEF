// @ts-check
const { defineConfig, devices } = require('@playwright/test');

/**
 * 🎯 QA 최적화: Flutter E2E 데모용 Playwright 설정
 * 
 * 개선사항:
 * - Flutter 특화 타임아웃 설정 (5초 → 30초)
 * - 모바일 뷰포트 최적화 (iPhone 15 Pro Max: 430x932)
 * - 비디오 녹화 설정 최적화
 * - 재시도 로직 강화
 * - Flutter 웹앱 특화 launchOptions
 * 
 * @see https://playwright.dev/docs/test-configuration
 */
module.exports = defineConfig({
  testDir: './tests',
  
  // Flutter 앱용 증가된 타임아웃
  timeout: 60 * 1000, // 60초 (기존 30초 → 60초)
  
  // Expect 타임아웃도 증가
  expect: {
    timeout: 30000 // 30초 (기존 5초 → 30초)
  },
  
  // 병렬 실행 설정
  fullyParallel: true,
  
  // CI 환경에서 test.only 금지
  forbidOnly: !!process.env.CI,
  
  // 재시도 로직 강화 (Flutter 로딩 이슈 대응)
  retries: process.env.CI ? 3 : 2, // 로컬에서도 2회 재시도
  
  // Worker 수 최적화
  workers: process.env.CI ? 1 : 2, // 로컬에서 2개 워커
  
  // Reporter 설정
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list'],
    ['json', { outputFile: 'test-results.json' }]
  ],
  
  // 공통 설정
  use: {
    baseURL: 'http://localhost:52378',
    
    // 추적 설정 강화
    trace: 'retain-on-failure',
    
    // 비디오 녹화 설정 (Flutter 데모용)
    video: {
      mode: 'on', // 항상 녹화
      size: { width: 430, height: 932 } // iPhone 15 Pro Max 크기
    },
    
    // 스크린샷 설정
    screenshot: {
      mode: 'only-on-failure',
      fullPage: true
    },
    
    // 기본 뷰포트 (모바일 최적화)
    viewport: { width: 430, height: 932 },
    
    // Flutter 웹앱 최적화 launch 옵션
    launchOptions: {
      slowMo: 300, // 적당한 속도 (500 → 300)
      args: [
        '--disable-web-security',
        '--disable-features=TranslateUI',
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-blink-features=AutomationControlled',
        '--window-size=450,950'
      ]
    },
    
    // 내비게이션 타임아웃 증가
    navigationTimeout: 45000, // 45초
    
    // 액션 타임아웃 증가  
    actionTimeout: 15000 // 15초
  },

  // 프로젝트 설정 (Flutter 데모 특화)
  projects: [
    {
      name: 'flutter-demo-mobile',
      use: { 
        ...devices['iPhone 13 Pro Max'],
        // Flutter 데모 특화 설정
        viewport: { width: 430, height: 932 },
        deviceScaleFactor: 3,
        isMobile: true,
        hasTouch: true,
        locale: 'ko-KR',
        timezoneId: 'Asia/Seoul',
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        
        // 비디오 녹화 설정
        contextOptions: {
          recordVideo: {
            dir: './videos/mobile',
            size: { width: 430, height: 932 }
          }
        },
        
        // Flutter 특화 launchOptions
        launchOptions: {
          slowMo: 300,
          args: [
            '--disable-web-security',
            '--disable-features=TranslateUI',
            '--no-sandbox',
            '--disable-dev-shm-usage',
            '--window-size=450,950',
            '--window-position=100,50'
          ]
        }
      },
    },

    {
      name: 'flutter-demo-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        // 데스크톱 버전용 설정
        viewport: { width: 430, height: 932 }, // 모바일 크기 유지
        
        contextOptions: {
          recordVideo: {
            dir: './videos/desktop',
            size: { width: 430, height: 932 }
          }
        },
        
        launchOptions: {
          slowMo: 300,
          args: [
            '--disable-web-security',
            '--disable-features=TranslateUI',
            '--window-size=450,950',
            '--window-position=100,50'
          ]
        }
      },
    },

    // 백업용 크롬 데스크톱 (전체 화면)
    {
      name: 'flutter-demo-fullscreen',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 },
        
        contextOptions: {
          recordVideo: {
            dir: './videos/fullscreen',
            size: { width: 1920, height: 1080 }
          }
        }
      },
    },
  ],

  // Flutter 개발 서버 설정
  webServer: {
    command: 'echo "Using existing Flutter server on port 52378"',
    port: 52378,
    reuseExistingServer: true,
    timeout: 30000, // 서버 준비 대기 시간
  },

  // 출력 디렉토리
  outputDir: 'test-results/',
  
  // 전역 설정
  globalSetup: undefined,
  globalTeardown: undefined,
  
  // 테스트 일치 패턴
  testMatch: '**/*{test,spec}.{js,ts}',
  
  // 테스트 무시 패턴
  testIgnore: '**/node_modules/**',
});