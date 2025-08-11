# GitHub Actions Flutter Web Deployment Guide

## 📋 Overview

This repository includes automated GitHub Actions workflows for building and deploying the Flutter web application to GitHub Pages. The workflow handles Flutter version management, Korean font setup, and demo mode deployment.

## 🚀 Available Workflows

### 1. `flutter_web_deploy.yml` (Basic)
- Standard Flutter web build and deployment
- Handles FVM setup and Korean fonts
- Deploys to GitHub Pages on main branch push

### 2. `flutter_web_deploy_enhanced.yml` (Recommended)
- Enhanced error handling and debugging
- Detailed build artifacts and summaries
- Better caching and performance optimization
- Debug mode for troubleshooting

## 🔧 Configuration

### Required Settings

1. **Enable GitHub Pages**:
   - Go to Settings → Pages
   - Source: "GitHub Actions"
   - Branch: Not applicable (using Actions)

2. **Set Repository Permissions**:
   - Settings → Actions → General
   - Workflow permissions: "Read and write permissions"
   - Allow GitHub Actions to create and approve pull requests: ✅

3. **Environment Variables**:
   - No secrets required (demo mode only)
   - All configuration in workflow files

## 🏗️ Build Process

The workflow performs these steps:

1. **Setup Environment**:
   - Ubuntu latest runner
   - Java 17 (required for Flutter)
   - FVM for Flutter version management

2. **Flutter Installation**:
   - Installs Flutter 3.32.5 via FVM
   - Configures Flutter for web builds
   - Caches dependencies for faster builds

3. **Korean Font Setup**:
   - Downloads NanumGothic fonts
   - Multiple fallback URLs
   - Creates placeholders if download fails

4. **Build Process**:
   - Installs dependencies (`flutter pub get`)
   - Runs code generation (Freezed/Riverpod)
   - Analyzes code quality
   - Runs tests (non-blocking)
   - Builds web release with demo mode

5. **Deployment**:
   - Uploads build artifacts
   - Deploys to GitHub Pages
   - Provides deployment URL and demo accounts

## 🧪 Local Testing

### Windows
```batch
# Run the test script
test_github_actions_locally.bat
```

### Linux/Mac
```bash
# Make script executable
chmod +x test_github_actions_locally.sh

# Run the test script
./test_github_actions_locally.sh
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. **Build Path Issues**
**Error**: "def_order_app: no such directory"
**Solution**: All workflows now use `working-directory: ./def_order_app`

#### 2. **Flutter Version Mismatch**
**Error**: "Flutter version X required but Y found"
**Solution**: FVM automatically installs and uses Flutter 3.32.5

#### 3. **Korean Font Issues**
**Error**: "PDF displays ??? instead of Korean text"
**Solution**: 
- Workflow downloads fonts automatically
- Multiple fallback URLs configured
- Placeholders created if download fails

#### 4. **Code Generation Failures**
**Error**: "build_runner failed"
**Solution**: 
- Non-blocking in workflow (continues on error)
- Run locally: `fvm flutter pub run build_runner build --delete-conflicting-outputs`

#### 5. **GitHub Pages 404**
**Error**: "Site not found after deployment"
**Solution**:
- Check Settings → Pages enabled
- Wait 5-10 minutes for initial deployment
- Verify base-href matches repository name

### Debug Mode

Enable debug mode for detailed output:

```yaml
# Trigger workflow with debug mode
workflow_dispatch:
  inputs:
    debug_mode: true
```

Or via GitHub UI:
1. Actions tab → Select workflow
2. Run workflow → Enable debug mode
3. Check logs for detailed information

## 📊 Build Artifacts

### Success Artifacts
- **Location**: Actions → Workflow run → Artifacts
- **Contents**: `build/web` directory
- **Retention**: 7 days

### Failed Build Artifacts
- **Location**: Actions → Failed workflow → Artifacts
- **Contents**: Build output and .dart_tool
- **Retention**: 3 days
- **Use for**: Debugging build failures

## 🔄 Manual Deployment

If automatic deployment fails:

1. **Download artifacts**:
   - Go to Actions → Latest successful build
   - Download `github-pages` artifact

2. **Manual deployment**:
   ```bash
   # Extract artifact
   unzip github-pages.zip
   
   # Deploy to gh-pages branch
   git checkout gh-pages
   cp -r * .
   git add .
   git commit -m "Manual deployment"
   git push
   ```

## 📱 PWA Access

After successful deployment:

### URL Format
```
https://[username].github.io/[repository-name]/
```

### Demo Accounts
| Type | Email | Password |
|------|-------|----------|
| Dealer (대리점) | dealer@demo.com | demo1234 |
| General (일반) | general@demo.com | demo1234 |

### PWA Installation
1. Open URL in Chrome/Edge
2. Click install icon in address bar
3. Or: Menu → Install app

## 🔐 Security Notes

- **Demo Mode Only**: Production credentials not exposed
- **No Secrets Required**: All demo data hardcoded
- **Safe for Public Repos**: No sensitive information in workflows

## 📈 Performance Optimization

### Caching Strategy
- Flutter SDK cached between builds
- Dependencies cached with pubspec.lock hash
- Build outputs cached for faster rebuilds

### Build Time Optimization
- Average build time: 3-5 minutes
- With cache: 2-3 minutes
- Parallel jobs where possible

## 🆘 Support

### Getting Help
1. Check workflow logs in Actions tab
2. Enable debug mode for detailed output
3. Run local test script for debugging
4. Check this README for common issues

### Reporting Issues
Create issue with:
- Workflow run URL
- Error messages from logs
- Steps to reproduce
- Expected vs actual behavior

## 📝 Maintenance

### Updating Flutter Version
1. Edit `FLUTTER_VERSION` in workflow files
2. Update `.fvmrc` in project
3. Test locally before pushing

### Adding New Features
1. Test locally with test script
2. Update workflow if needed
3. Document changes in this README

## ✅ Checklist for New Setup

- [ ] GitHub Pages enabled in Settings
- [ ] Workflow permissions configured
- [ ] First push to main branch done
- [ ] Wait 5-10 minutes for deployment
- [ ] Test PWA URL in browser
- [ ] Verify demo accounts work
- [ ] Install as PWA (optional)

---

**Last Updated**: 2024
**Maintainer**: Development Team
**Flutter Version**: 3.32.5
**Demo Mode**: Always enabled for GitHub Pages