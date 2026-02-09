#!/bin/bash

# 입고요청서 관리시스템 Firebase 배포 스크립트
# 사용법: ./deploy.sh

echo "🚀 Firebase 배포를 시작합니다..."

# 현재 디렉토리 확인
cd "$(dirname "$0")"

# 최신 index.html을 public 디렉토리에 복사
echo "📁 파일을 복사하는 중..."
cp index.html public/

# Firebase에 배포
echo "☁️  Firebase에 배포하는 중..."
firebase deploy

# 배포 완료
echo "✅ 배포가 완료되었습니다!"
echo "🌐 사이트 URL: https://inventory-management-212d7.web.app"
echo ""
echo "📊 Firebase Console: https://console.firebase.google.com/project/inventory-management-212d7/overview"