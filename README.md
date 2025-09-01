# 입고요청서 관리시스템 v4.0

> Firebase 기반 실시간 물류관리 웹 애플리케이션

[![Firebase](https://img.shields.io/badge/Firebase-ffca28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![Version](https://img.shields.io/badge/version-4.0-blue.svg)](https://github.com/your-username/inventory-management)

## 📋 개요

입고요청서 관리시스템 v4.0은 장애인생산품판매시설을 위한 종합적인 물류관리 솔루션입니다. Firebase를 통한 실시간 동기화로 여러 기기에서 동시에 사용할 수 있으며, 생산시설과 품목을 동적으로 관리할 수 있습니다.

## ✨ 주요 기능

### 🏭 생산시설 관리
- **동적 추가**: 새로운 생산시설을 실시간으로 추가
- **자동 동기화**: 모든 연결된 기기에 즉시 반영
- **중복 검증**: 동일한 생산시설명 등록 방지

### 📦 품목 관리
- **다중 생산시설 지원**: 생산시설별 품목 분류 관리
- **상세 정보**: 품목명, 규격, 수량, 단위 정보 관리
- **중복 방지**: 동일 생산시설 내 중복 품목 검증

### 📊 실시간 재고 관리
- **보관품 현황**: 생산시설별 품목 현황 실시간 조회
- **수량 조정**: 직관적인 인터페이스로 재고 수량 수정
- **필터링**: 생산시설별 보관품 필터링 기능

### 📝 입고요청서 작성
- **자동 계산**: 잔량 = 초기수량 - 입고수량 자동 계산
- **음수 경고**: 재고 부족 시 시각적 경고 표시
- **일괄 처리**: 여러 품목 동시 입고요청 처리

### 📈 입고이력 추적
- **완전한 추적**: 모든 입고 활동 자동 기록
- **필터링**: 날짜별, 생산시설별 이력 조회
- **이력 관리**: 잘못된 입고 기록 삭제 및 재고 복원

### 🔄 실시간 동기화
- **멀티디바이스**: 여러 기기에서 동시 사용 가능
- **즉시 반영**: 한 기기에서의 변경사항이 다른 기기에 즉시 반영
- **충돌 방지**: Firebase를 통한 데이터 일관성 보장

### 🖨️ 출력 및 내보내기
- **인쇄 기능**: 각 시트별 개별 인쇄 지원
- **엑셀 내보내기**: 보관품 및 입고이력 데이터 Excel 파일로 내보내기
- **인쇄 미리보기**: 입고요청서 인쇄 전 미리보기 기능

## 🚀 빠른 시작

### 1. 리포지토리 클론
```bash
git clone https://github.com/your-username/inventory-management.git
cd inventory-management
```

### 2. 웹 서버 실행
```bash
# Python을 사용한 로컬 서버
python3 -m http.server 8000

# 또는 Node.js를 사용한 서버
npx http-server -p 8000
```

### 3. 브라우저에서 접속
```
http://localhost:8000
```

### 4. Firebase 연결 확인
- 상단의 Firebase 연결 상태 표시줄이 초록색인지 확인
- "Firebase 연결됨 (실시간 동기화)" 메시지 확인

## 🛠️ 설정 및 배포

### GitHub Pages 배포
1. GitHub 리포지토리에 코드 업로드
2. Repository Settings → Pages 메뉴 이동
3. Source: "Deploy from a branch" 선택
4. Branch: "main" 선택, Folder: "/ (root)" 선택
5. Save 버튼 클릭
6. 제공된 URL로 접속

### Firebase 설정 (선택사항)
자체 Firebase 프로젝트를 사용하려면:
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 새 프로젝트 생성
3. Firestore Database 활성화
4. `index.html`의 Firebase 설정 정보 교체

## 📱 사용 방법

### 생산시설 추가
1. 상단 **"생산시설 추가"** 버튼 클릭
2. 생산시설명 입력
3. **"추가"** 버튼 클릭

### 품목 추가  
1. 상단 **"품목 추가"** 버튼 클릭
2. 생산시설 선택
3. 품목명, 규격, 수량, 단위 입력
4. **"추가"** 버튼 클릭

### 입고요청서 작성
1. **"입고요청서"** 탭 선택
2. 입고수량 입력 (잔량 자동 계산)
3. **"입고 요청 등록"** 버튼 클릭

### 데이터 내보내기
1. **"엑셀로 내보내기"** 버튼 클릭
2. 생성된 Excel 파일 다운로드

## 🔧 기술 스택

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Firebase Firestore
- **실시간 동기화**: Firebase Realtime Listeners
- **스타일링**: 커스텀 CSS (반응형 디자인)
- **데이터 내보내기**: SheetJS (xlsx)
- **호스팅**: GitHub Pages (권장)

## 📊 시스템 요구사항

### 브라우저 지원
- Chrome 80+ (권장)
- Firefox 75+
- Safari 13+
- Edge 80+

### 네트워크
- 안정적인 인터넷 연결 (Firebase 동기화)
- HTTPS 프로토콜 (Firebase 보안 요구사항)

## 🆕 v4.0 업데이트 내역

### 새로운 기능
- ✨ 동적 생산시설 추가 기능
- 🏭 실시간 생산시설 관리
- 📦 생산시설별 품목 추가 시스템
- 🔄 향상된 Firebase 연동 안정성

### 개선사항
- 🎨 직관적인 모달 UI 디자인
- ⚡ 더 빠른 데이터 로딩
- 🛡️ 데이터 검증 로직 강화
- 📱 모바일 환경 최적화

### 기술적 개선
- 🔧 코드 모듈화 및 최적화
- 🔒 Firebase 보안 규칙 개선
- 💾 LocalStorage 폴백 시스템 강화

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 확인하세요.

## 📞 지원 및 문의

- 📧 Email: support@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/your-username/inventory-management/issues)
- 📖 문서: [Technical Documentation](./TECHNICAL.md)

## 🙏 감사의 말

이 프로젝트는 장애인생산품판매시설의 효율적인 물류관리를 위해 개발되었습니다. 모든 사용자와 기여자분들께 감사드립니다.

---

**Made with ❤️ for Better Inventory Management**