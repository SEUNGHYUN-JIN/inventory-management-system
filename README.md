# 입고요청서 관리시스템 v4.1

> Firebase 기반 실시간 물류관리 웹 애플리케이션 (관리자 모드 지원)

[![Firebase](https://img.shields.io/badge/Firebase-ffca28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![Version](https://img.shields.io/badge/version-4.1-blue.svg)](https://github.com/your-username/inventory-management)
[![Security](https://img.shields.io/badge/Security-Enhanced-green.svg)](https://github.com/your-username/inventory-management)

## 📋 개요

입고요청서 관리시스템 v4.1은 장애인생산품판매시설을 위한 종합적인 물류관리 솔루션입니다. Firebase를 통한 실시간 동기화로 여러 기기에서 동시에 사용할 수 있으며, **관리자 인증 시스템**을 통해 데이터 보안을 강화했습니다. 생산시설과 품목의 추가/수정/삭제가 관리자 권한으로 제한되어 더욱 안전합니다.

## ✨ 주요 기능

### 🔐 **NEW** 관리자 인증 시스템

- **보안 강화**: 관리자 로그인을 통한 데이터 보호
- **권한 제한**: 생산시설/품목 관리는 관리자만 가능
- **테스트 계정**: ID: `admin`, Password: `admin`
- **세션 관리**: 로그인/로그아웃 기능

### 🏭 생산시설 관리 (관리자 전용)

- **동적 추가**: 새로운 생산시설을 실시간으로 추가
- **수정 기능**: 기존 생산시설명 수정 (연관 데이터 자동 업데이트)
- **삭제 기능**: 품목이 없는 생산시설 안전 삭제
- **자동 동기화**: 모든 연결된 기기에 즉시 반영

### 📦 품목 관리 (관리자 전용)

- **다중 생산시설 지원**: 생산시설별 품목 분류 관리
- **상세 수정**: 품목명, 규격, 수량, 단위 정보 수정
- **필터링**: 생산시설별 품목 목록 필터링
- **안전 삭제**: 품목 삭제 전 확인 절차

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
- **규격 표시**: 새 이력은 저장 시 규격 포함. **과거 이력**은 같은 생산시설·품목의 현재 보관품 규격을 찾아 자동 표시
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

### 2. Firebase 설정

- **GitHub Pages 배포**: 저장소에 포함된 `firebase-config.pages.js`를 사용합니다. 푸시만 하면 Firebase에 연결됩니다.
- **로컬 개발**: 선택적으로 `firebase-config.js`(`.gitignore` 대상)를 두면 `.pages.js`를 덮어써서 사용합니다. 없으면 `.pages.js` 설정을 씁니다.
- **Firebase는 비관계형(NoSQL) Firestore**이며, **별도 백엔드 서버 없이** 브라우저(클라이언트)에서 직접 Firestore에 읽기/쓰기합니다. 입력·수정·삭제는 모두 클라이언트에서 바로 반영됩니다.

### 3. 배포 방법 선택

#### Option A: Firebase Hosting (권장)

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 초기화
firebase init hosting

# 배포
firebase deploy
```

#### Option B: GitHub Pages

1. GitHub 리포지토리에 코드 푸시
2. **Settings → Pages** 이동
3. **Source**: Deploy from a branch
4. **Branch**: `master` 또는 `main`, **Folder**: `/ (root)` (루트의 `index.html` 사용)
5. Save 후 수 분 뒤 `https://<username>.github.io/<repo-name>/` 에서 접속
6. Firebase 연결은 저장소에 포함된 `firebase-config.pages.js`로 자동 적용됩니다.

#### Option C: 로컬 개발 서버

```bash
# Python을 사용한 로컬 서버
python3 -m http.server 8000

# 또는 Node.js를 사용한 서버
npx http-server -p 8000
```

### 4. 브라우저에서 접속

- Firebase Hosting: `https://your-project.web.app`
- GitHub Pages: `https://username.github.io/repository-name`
- 로컬: `http://localhost:8000`

### 5. 관리자 로그인

- 우측 상단 **🔐 관리자 모드** 버튼 클릭
- ID: `admin`, Password: `admin` 입력
- 관리 기능 활성화 확인

## 🛠️ 보안 및 커스터마이징

### 관리자 비밀번호 변경

`index.html` 파일에서 다음 부분을 수정하세요:

```javascript
// 1820번째 줄 근처
if (adminId === 'your-admin-id' && adminPassword === 'your-secure-password') {
```

### GitHub Pages에서 Firebase 연결이 안 될 때

**증상:** 사이트는 뜨는데 "Firebase 연결 실패" 또는 로컬 저장소 모드만 동작함.

**원인:** Google Cloud에서 API 키에 **HTTP referrer 제한**이 걸려 있으면, GitHub Pages 도메인(`*.github.io`)에서 요청이 막힙니다.

**해결:**

1. [Google Cloud Console](https://console.cloud.google.com/) 접속 → 프로젝트 **inventory-management-212d7** 선택
2. **APIs & Services** → **Credentials** → **API keys** 이동
3. 웹 앱에 쓰는 API 키(예: 브라우저 키) 클릭
4. **Application restrictions** → **HTTP referrers (websites)** 선택
5. **Website restrictions**에 아래 한 줄 이상 추가 후 저장:
   - `https://seunghyun-jin.github.io/inventory-management-system/*`
   - 또는 전체 허용: `https://*.github.io/*`
6. 저장 후 1–2분 지나서 GitHub Pages 사이트 새로고침 (강력 새로고침: Ctrl+Shift+R 또는 Cmd+Shift+R)

### Firebase 프로젝트 연동

자체 Firebase 프로젝트를 사용하려면:

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 새 프로젝트 생성
3. Firestore Database 활성화
4. `firebase-config.pages.js`(및 로컬용 `firebase-config.js`)의 Firebase 설정 정보 교체:

```javascript
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "your-sender-id",
  appId: "your-app-id",
};
```

## 📱 사용 방법

### 관리자 로그인

1. 우측 상단 **🔐 관리자 모드** 버튼 클릭
2. ID: `admin`, Password: `admin` 입력
3. 관리자 모드 활성화 확인

### 생산시설 관리 (관리자만)

1. 관리자 모드에서 **"생산시설 추가"** 또는 **"생산시설 관리"** 클릭
2. **추가**: 새 생산시설명 입력 후 추가
3. **수정**: 기존 생산시설명 클릭하여 수정
4. **삭제**: 품목이 없는 생산시설만 삭제 가능

### 품목 관리 (관리자만)

1. 관리자 모드에서 **"품목 추가"** 또는 **"품목 관리"** 클릭
2. **추가**: 생산시설, 품목명, 규격, 수량, 단위 입력
3. **수정**: 기존 품목 정보 수정
4. **삭제**: 불필요한 품목 삭제

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

## 🆕 v4.1 업데이트 내역

### 새로운 기능

- 🔐 **관리자 인증 시스템** - 로그인 기반 권한 관리
- ✏️ **생산시설 수정/삭제** - 기존 데이터 완전 관리
- 📝 **품목 수정/삭제** - 상세 품목 정보 편집
- 🛡️ **보안 강화** - 민감한 기능 접근 제한
- 🏠 **Firebase Hosting 지원** - 향상된 배포 옵션

### 개선사항

- 🎨 관리자 모드 전용 UI 분리
- 📍 관리자 버튼을 헤더로 이동
- ⚠️ 데이터 변경 전 확인 절차 강화
- 🔄 연관 데이터 자동 업데이트 (생산시설명 변경 시)

### 보안 개선

- 🔒 관리자 전용 기능 분리
- 🚫 무단 데이터 조작 방지
- 🛡️ Firestore 보안 규칙 추가
- 🔑 세션 기반 권한 관리

### 기술적 개선

- 📁 Firebase Hosting 구성 파일 추가
- 🔧 모듈화된 관리자 기능
- 💾 향상된 오류 처리
- 🔄 실시간 동기화 안정성 개선

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
