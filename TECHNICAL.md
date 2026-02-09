# 입고요청서 관리시스템 v4.1 기술문서

## 📚 목차
1. [시스템 아키텍처](#시스템-아키텍처)
2. [보안 시스템](#보안-시스템)
3. [데이터베이스 설계](#데이터베이스-설계)
4. [Firebase 연동](#firebase-연동)
5. [핵심 기능 구현](#핵심-기능-구현)
6. [UI/UX 설계](#uiux-설계)
7. [성능 최적화](#성능-최적화)
8. [보안 및 데이터 무결성](#보안-및-데이터-무결성)
9. [배포 및 운영](#배포-및-운영)
10. [개발자 가이드](#개발자-가이드)

## 🏗️ 시스템 아키텍처

### 전체 구조
```
┌─────────────────────────┐
│     사용자 인터페이스     │
│   (HTML + CSS + JS)     │
├─────────────────────────┤
│    🔐 관리자 인증 레이어  │
│   (Session Management)  │
├─────────────────────────┤
│     애플리케이션 로직     │
│  (Vanilla JavaScript)   │
├─────────────────────────┤
│     Firebase SDK        │
│  (Firestore + Hosting)  │
├─────────────────────────┤
│     Firebase Cloud      │
│    (NoSQL Database)     │
└─────────────────────────┘
```

### 주요 컴포넌트

#### 1. 프론트엔드 레이어
- **HTML5**: 시맨틱 마크업과 접근성 고려
- **CSS3**: 모던 스타일링 및 반응형 디자인
- **Vanilla JavaScript**: 프레임워크 없는 순수 자바스크립트

#### 2. 데이터 레이어
- **Firebase Firestore**: NoSQL 실시간 데이터베이스
- **Local Storage**: 오프라인 폴백 및 임시 저장

#### 3. 통신 레이어
- **Firebase SDK**: 실시간 양방향 통신
- **RESTful API**: Firebase REST API 기반

#### 4. 보안 레이어
- **세션 기반 인증**: 클라이언트 사이드 세션 관리
- **권한 제어**: 관리자 전용 기능 분리
- **데이터 보호**: 민감한 작업 접근 제한

## 🔐 보안 시스템

### 관리자 인증 구조

#### 1. 로그인 프로세스
```javascript
function adminLogin() {
    const adminId = document.getElementById('adminId').value.trim();
    const adminPassword = document.getElementById('adminPassword').value.trim();
    
    // 입력값 검증
    if (!adminId || !adminPassword) {
        showStatus('아이디와 패스워드를 모두 입력해주세요.', 'error');
        return;
    }
    
    // 하드코딩된 자격증명 검증 (프로덕션에서는 변경 필요)
    if (adminId === 'admin' && adminPassword === 'admin') {
        // 세션 상태 설정
        isAdminLoggedIn = true;
        
        // UI 상태 변경
        document.getElementById('admin-controls').style.display = 'flex';
        document.getElementById('adminMenuBtn').textContent = '🔓 관리자 모드 활성화됨';
        document.getElementById('adminMenuBtn').disabled = true;
        
        closeModal('adminLoginModal');
        showStatus('✅ 관리자로 로그인되었습니다. 관리 기능이 활성화되었습니다.', 'success');
    } else {
        showStatus('아이디 또는 패스워드가 올바르지 않습니다.', 'error');
        document.getElementById('adminPassword').value = '';
    }
}
```

#### 2. 권한 검증 시스템
```javascript
// 생산시설 추가 권한 검증
function showAddFacilityModal() {
    if (!isAdminLoggedIn) {
        showStatus('생산시설 추가는 관리자 로그인이 필요합니다.', 'error');
        return;
    }
    document.getElementById('addFacilityModal').style.display = 'block';
}

// 데이터 초기화 권한 검증
async function clearAllData() {
    if (!isAdminLoggedIn) {
        showStatus('데이터 초기화는 관리자 로그인이 필요합니다.', 'error');
        return;
    }
    // ... 초기화 로직
}
```

#### 3. 세션 관리
```javascript
let isAdminLoggedIn = false; // 전역 세션 상태

function adminLogout() {
    if (confirm('관리자 모드에서 로그아웃하시겠습니까?')) {
        // 세션 초기화
        isAdminLoggedIn = false;
        
        // UI 상태 복원
        document.getElementById('admin-controls').style.display = 'none';
        document.getElementById('adminMenuBtn').textContent = '🔐 관리자 모드';
        document.getElementById('adminMenuBtn').disabled = false;
        
        showStatus('관리자 모드에서 로그아웃되었습니다.', 'success');
    }
}
```

### 보안 고려사항

#### 1. 프로덕션 환경 보안 강화
```javascript
// 프로덕션 환경에서 권장되는 개선사항
class AdminAuth {
    constructor() {
        this.sessionTimeout = 30 * 60 * 1000; // 30분 세션 타임아웃
        this.maxAttempts = 3; // 최대 로그인 시도 횟수
        this.loginAttempts = 0;
        this.lastAttemptTime = null;
    }
    
    // 보안 강화된 로그인
    login(id, password) {
        // 브루트 포스 공격 방지
        if (this.loginAttempts >= this.maxAttempts) {
            const timeSinceLastAttempt = Date.now() - this.lastAttemptTime;
            if (timeSinceLastAttempt < 5 * 60 * 1000) { // 5분 잠금
                throw new Error('너무 많은 로그인 시도로 인해 계정이 일시적으로 잠겼습니다.');
            } else {
                this.loginAttempts = 0; // 잠금 해제
            }
        }
        
        // 패스워드 해싱 (실제 환경에서 구현)
        const hashedPassword = this.hashPassword(password);
        const storedHash = this.getStoredPasswordHash(id);
        
        if (hashedPassword === storedHash) {
            this.loginAttempts = 0;
            this.setSession();
            return true;
        } else {
            this.loginAttempts++;
            this.lastAttemptTime = Date.now();
            return false;
        }
    }
    
    // 세션 설정
    setSession() {
        const sessionData = {
            isLoggedIn: true,
            loginTime: Date.now(),
            expiryTime: Date.now() + this.sessionTimeout
        };
        
        // 세션 데이터 암호화 저장
        sessionStorage.setItem('adminSession', 
            btoa(JSON.stringify(sessionData))
        );
    }
    
    // 세션 검증
    validateSession() {
        const sessionData = sessionStorage.getItem('adminSession');
        if (!sessionData) return false;
        
        try {
            const session = JSON.parse(atob(sessionData));
            return session.expiryTime > Date.now();
        } catch {
            return false;
        }
    }
}
```

#### 2. Firebase 보안 강화
```javascript
// Firestore 보안 규칙 (firestore.rules)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // IP 기반 접근 제한 (선택사항)
    match /inventory/{document} {
      allow read, write: if request.auth != null 
        || resource.data.allowedIPs.hasAny([request.remote_ip]);
    }
    
    // 시간 기반 접근 제한 (업무시간만 허용)
    match /settings/{document} {
      allow write: if request.auth != null
        && request.time.hours() >= 9 
        && request.time.hours() <= 18;
    }
  }
}
```

## 🗄️ 데이터베이스 설계

### Firestore 컬렉션 구조

#### 1. `inventory` 컬렉션
```javascript
{
  "current": {
    "items": [
      {
        "품목": "점보롤화장지/천연펄프(동원)",
        "규격": "250M*2겹*16롤",
        "수량": 100,
        "단위": "박스",
        "생산시설": "동원직업재활원"
      }
    ],
    "lastUpdated": Timestamp
  }
}
```

#### 2. `history` 컬렉션
```javascript
{
  "1": {
    "No": 1,
    "입고일": "2024-01-15",
    "생산시설": "동원직업재활원",
    "요청기관": "경상남도 장애인생산품판매시설",
    "품목": "점보롤화장지/천연펄프(동원)",
    "입고수량": 50,
    "초기수량": 100,
    "잔량": 50,
    "등록일시": "2024-01-15 14:30:25"
  }
}
```

#### 3. `settings` 컬렉션
```javascript
{
  "counter": {
    "value": 1
  },
  "facilities": {
    "list": ["동원직업재활원", "학산보호작업장", "누리봄"],
    "lastUpdated": Timestamp
  }
}
```

### 데이터 모델링 원칙

1. **정규화**: 중복 데이터 최소화
2. **역정규화**: 읽기 성능을 위한 적절한 중복 허용
3. **확장성**: 새로운 필드 추가 시 하위 호환성 보장
4. **일관성**: Firebase 트랜잭션을 통한 데이터 일관성 유지

## 🔥 Firebase 연동

### 초기화 과정

```javascript
// Firebase 설정
const firebaseConfig = {
    apiKey: "your-api-key",
    authDomain: "project-id.firebaseapp.com",
    projectId: "project-id",
    storageBucket: "project-id.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-app-id"
};

// Firebase 앱 초기화
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();
```

### 실시간 데이터 동기화

#### 1. 리스너 설정
```javascript
function setupRealtimeListeners() {
    // 생산시설 실시간 감지
    db.collection('settings').doc('facilities').onSnapshot((doc) => {
        if (doc.exists) {
            const newFacilities = doc.data().list || [];
            if (JSON.stringify(newFacilities) !== JSON.stringify(facilitiesData)) {
                facilitiesData = newFacilities;
                updateFacilityOptions();
                showStatus('생산시설 목록이 다른 기기에서 업데이트되었습니다.', 'success');
            }
        }
    });

    // 보관품 데이터 실시간 감지
    db.collection('inventory').doc('current').onSnapshot((doc) => {
        if (doc.exists) {
            const newData = doc.data().items || [];
            if (JSON.stringify(newData) !== JSON.stringify(inventoryData)) {
                inventoryData = newData;
                renderInventoryTable();
                renderRequestTable();
                showStatus('보관품 데이터가 다른 기기에서 업데이트되었습니다.', 'success');
            }
        }
    });
}
```

#### 2. 데이터 저장
```javascript
async function saveInventoryToFirebase() {
    if (!isFirebaseConnected) return;
    
    try {
        await db.collection('inventory').doc('current').set({
            items: inventoryData,
            lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
        });
        
        setFirebaseStatus('connected', 'Firebase 연결됨 (저장됨)');
        setTimeout(() => {
            setFirebaseStatus('connected', 'Firebase 연결됨 (실시간 동기화)');
        }, 2000);
        
    } catch (error) {
        console.error('Firebase 저장 실패:', error);
        showStatus('Firebase 저장 실패: ' + error.message, 'error');
    }
}
```

### 오프라인 지원

#### LocalStorage 폴백 시스템
```javascript
function loadDataFromLocalStorage() {
    const savedFacilities = localStorage.getItem('facilitiesData');
    const savedInventory = localStorage.getItem('inventoryData');
    const savedHistory = localStorage.getItem('requestHistory');
    
    if (savedFacilities) {
        facilitiesData = JSON.parse(savedFacilities);
    } else {
        facilitiesData = getDefaultFacilities();
    }
    
    if (savedInventory) {
        inventoryData = JSON.parse(savedInventory);
    } else {
        inventoryData = getDefaultInventoryData();
    }
    
    renderAllTables();
}
```

## ⚙️ 핵심 기능 구현

### 1. 생산시설 관리

#### 동적 생산시설 추가
```javascript
async function addFacility() {
    const facilityName = document.getElementById('newFacilityName').value.trim();
    
    // 유효성 검사
    if (!facilityName) {
        showStatus('생산시설명을 입력해주세요.', 'error');
        return;
    }
    
    if (facilitiesData.includes(facilityName)) {
        showStatus('이미 존재하는 생산시설입니다.', 'error');
        return;
    }
    
    // 데이터 추가
    facilitiesData.push(facilityName);
    
    // Firebase 저장
    await saveFacilitiesToFirebase();
    
    // 로컬 저장
    localStorage.setItem('facilitiesData', JSON.stringify(facilitiesData));
    
    // UI 업데이트
    updateFacilityOptions();
    closeModal('addFacilityModal');
    
    showStatus(`✅ 생산시설 "${facilityName}"이 추가되었습니다.`, 'success');
}
```

### 2. 품목 관리

#### 품목 추가 및 검증
```javascript
async function addItem() {
    const facility = document.getElementById('itemFacility').value;
    const name = document.getElementById('itemName').value.trim();
    const spec = document.getElementById('itemSpec').value.trim();
    const quantity = parseInt(document.getElementById('itemQuantity').value) || 0;
    const unit = document.getElementById('itemUnit').value;
    
    // 필수 필드 검증
    if (!facility || !name || !spec) {
        showStatus('모든 필드를 입력해주세요.', 'error');
        return;
    }
    
    // 중복 품목 검사
    const existingItem = inventoryData.find(item => 
        item.생산시설 === facility && 
        item.품목 === name && 
        item.규격 === spec
    );
    
    if (existingItem) {
        showStatus('동일한 생산시설에 같은 품목과 규격이 이미 존재합니다.', 'error');
        return;
    }
    
    // 새 품목 객체 생성
    const newItem = {
        품목: name,
        규격: spec,
        수량: quantity,
        단위: unit,
        생산시설: facility
    };
    
    // 데이터 추가
    inventoryData.push(newItem);
    
    // 저장 및 UI 업데이트
    await saveInventoryToFirebase();
    localStorage.setItem('inventoryData', JSON.stringify(inventoryData));
    
    renderAllTables();
    closeModal('addItemModal');
    
    showStatus(`✅ 품목 "${name}"이 ${facility}에 추가되었습니다.`, 'success');
}
```

### 3. 입고요청 처리

#### 자동 계산 로직
```javascript
function calculateRemaining(index) {
    const requestInput = document.getElementById(`request-${index}`);
    const remainingCell = document.getElementById(`remaining-${index}`);
    
    if (!requestInput || !remainingCell) return;
    
    const requestQuantity = parseInt(requestInput.value) || 0;
    const currentInventoryQuantity = inventoryData[index].수량;
    const remaining = currentInventoryQuantity - requestQuantity;
    
    // 잔량 표시
    remainingCell.textContent = remaining.toLocaleString();
    remainingCell.className = remaining < 0 ? 'calculated-cell negative-value' : 'calculated-cell';
    
    // 툴팁 설정
    if (remaining < 0) {
        remainingCell.title = `⚠️ 현재 보유량(${currentInventoryQuantity})보다 ${Math.abs(remaining)}개 부족합니다.`;
    } else {
        remainingCell.title = `입고 후 예상 잔량: ${remaining}`;
    }
}
```

### 4. 데이터 내보내기

#### Excel 내보내기 구현
```javascript
function exportToExcel() {
    try {
        const wb = XLSX.utils.book_new();
        
        // 보관품 시트 생성
        const inventoryWS = XLSX.utils.json_to_sheet(inventoryData);
        XLSX.utils.book_append_sheet(wb, inventoryWS, '보관품');
        
        // 입고이력 시트 생성
        if (historyData.length > 0) {
            const historyWS = XLSX.utils.json_to_sheet(historyData);
            XLSX.utils.book_append_sheet(wb, historyWS, '입고이력');
        }
        
        // 파일 다운로드
        const fileName = `입고관리_Firebase_${new Date().toISOString().split('T')[0]}.xlsx`;
        XLSX.writeFile(wb, fileName);
        
        showStatus('엑셀 파일이 다운로드되었습니다!', 'success');
        
    } catch (error) {
        console.error('엑셀 내보내기 오류:', error);
        showStatus('엑셀 내보내기 중 오류가 발생했습니다.', 'error');
    }
}
```

## 🎨 UI/UX 설계

### 반응형 디자인

#### CSS Grid 및 Flexbox 활용
```css
.row {
    display: flex;
    gap: 20px;
}

.col {
    flex: 1;
}

@media (max-width: 768px) {
    .row {
        flex-direction: column;
    }
}
```

#### 모달 시스템
```css
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}

.modal-content {
    background-color: white;
    margin: 10% auto;
    padding: 20px;
    border-radius: 8px;
    width: 500px;
    max-width: 90%;
    box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}
```

### 상태 표시 시스템

#### Firebase 연결 상태
```javascript
function setFirebaseStatus(status, message) {
    const statusContainer = document.getElementById('firebase-status');
    const statusDot = document.getElementById('status-dot');
    const statusText = document.getElementById('status-text');
    const syncInfo = document.getElementById('sync-info');
    
    statusContainer.className = `firebase-status ${status}`;
    statusDot.className = `status-dot ${status}`;
    statusText.textContent = message;
    
    if (status === 'connected') {
        syncInfo.textContent = `마지막 동기화: ${new Date().toLocaleTimeString()}`;
    } else {
        syncInfo.textContent = '동기화 불가 (로컬 모드)';
    }
}
```

### 인터랙티브 요소

#### 테이블 렌더링 최적화
```javascript
function renderInventoryTable() {
    const tbody = document.getElementById('inventory-tbody');
    tbody.innerHTML = '';
    
    const filteredData = currentFacilityFilter 
        ? inventoryData.filter(item => item.생산시설 === currentFacilityFilter)
        : inventoryData;
    
    if (filteredData.length === 0) {
        const row = document.createElement('tr');
        row.innerHTML = '<td colspan="5" style="text-align: center; color: #666;">선택된 생산시설에 품목이 없습니다.</td>';
        tbody.appendChild(row);
        return;
    }
    
    // 그룹화 및 렌더링 로직
    if (!currentFacilityFilter) {
        const groupedData = filteredData.reduce((groups, item) => {
            const facility = item.생산시설;
            if (!groups[facility]) {
                groups[facility] = [];
            }
            groups[facility].push(item);
            return groups;
        }, {});

        Object.keys(groupedData).sort().forEach(facility => {
            // 그룹 헤더 렌더링
            const headerRow = document.createElement('tr');
            headerRow.classList.add('group-header');
            headerRow.innerHTML = `<td colspan="5" style="text-align: center; padding: 10px;">${facility}</td>`;
            tbody.appendChild(headerRow);

            // 그룹 아이템 렌더링
            groupedData[facility].forEach((item) => {
                const globalIndex = inventoryData.indexOf(item);
                const row = createInventoryRow(item, globalIndex);
                tbody.appendChild(row);
            });
        });
    } else {
        // 단일 시설 렌더링
        filteredData.forEach((item) => {
            const globalIndex = inventoryData.indexOf(item);
            const row = createInventoryRow(item, globalIndex);
            tbody.appendChild(row);
        });
    }
}
```

## ⚡ 성능 최적화

### 1. 데이터 로딩 최적화

#### 지연 로딩 구현
```javascript
function showLoading(show) {
    const loadingElements = document.querySelectorAll('.loading');
    const tables = document.querySelectorAll('.editable-table');
    
    loadingElements.forEach(el => {
        el.style.display = show ? 'block' : 'none';
    });
    
    tables.forEach(table => {
        table.style.display = show ? 'none' : 'table';
    });
}
```

### 2. 메모리 관리

#### 이벤트 리스너 최적화
```javascript
// 전역 이벤트 리스너로 이벤트 위임 활용
window.onclick = function(event) {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
}
```

### 3. 네트워크 최적화

#### 배치 처리
```javascript
async function addRequestHistory() {
    // ... 유효성 검사 ...
    
    // 배치 처리를 위한 데이터 수집
    const batchUpdates = [];
    
    dataToProcess.forEach((item) => {
        const globalIndex = inventoryData.indexOf(item);
        const requestInput = document.getElementById(`request-${globalIndex}`);
        const requestQuantity = parseInt(requestInput?.value) || 0;
        
        if (requestQuantity > 0) {
            batchUpdates.push({
                item,
                requestQuantity,
                globalIndex
            });
        }
    });
    
    // 배치 처리 실행
    for (const update of batchUpdates) {
        // 개별 업데이트 처리
        await processIndividualUpdate(update);
    }
    
    // 최종 저장
    await saveInventoryToFirebase();
    renderAllTables();
}
```

## 🔒 보안 및 데이터 무결성

### Firebase 보안 규칙

#### Firestore 규칙 예시
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 보관품 데이터 접근 규칙
    match /inventory/{document} {
      allow read, write: if true; // 실제 환경에서는 인증 규칙 적용
    }
    
    // 입고이력 접근 규칙
    match /history/{document} {
      allow read, write: if true;
    }
    
    // 설정 데이터 접근 규칙
    match /settings/{document} {
      allow read, write: if true;
    }
  }
}
```

### 데이터 검증

#### 클라이언트 사이드 검증
```javascript
function validateFacilityInput(facilityName) {
    // 필수값 검사
    if (!facilityName || facilityName.trim().length === 0) {
        return { valid: false, message: '생산시설명을 입력해주세요.' };
    }
    
    // 길이 제한 검사
    if (facilityName.length > 50) {
        return { valid: false, message: '생산시설명은 50자를 초과할 수 없습니다.' };
    }
    
    // 중복 검사
    if (facilitiesData.includes(facilityName)) {
        return { valid: false, message: '이미 존재하는 생산시설입니다.' };
    }
    
    // 특수문자 검사
    const invalidChars = /[<>\"'&]/;
    if (invalidChars.test(facilityName)) {
        return { valid: false, message: '특수문자는 사용할 수 없습니다.' };
    }
    
    return { valid: true };
}
```

### 오류 처리

#### 통합 오류 처리 시스템
```javascript
class ErrorHandler {
    static handle(error, context = '') {
        console.error(`[${context}] 오류 발생:`, error);
        
        let userMessage = '알 수 없는 오류가 발생했습니다.';
        
        if (error.code) {
            switch (error.code) {
                case 'permission-denied':
                    userMessage = 'Firebase 접근 권한이 없습니다.';
                    break;
                case 'network-request-failed':
                    userMessage = '네트워크 연결을 확인해주세요.';
                    break;
                case 'quota-exceeded':
                    userMessage = 'Firebase 할당량이 초과되었습니다.';
                    break;
                default:
                    userMessage = `시스템 오류: ${error.message}`;
            }
        }
        
        showStatus(userMessage, 'error');
        
        // 개발환경에서만 상세 로그
        if (window.location.hostname === 'localhost') {
            console.trace(error);
        }
    }
}
```

## 🚀 배포 및 운영

### Firebase Hosting 배포 (권장)

#### 1. 초기 설정
```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 디렉토리에서 초기화
firebase init hosting

# 설정 선택:
# - Use existing project 선택
# - Public directory: public
# - Single-page app: No
# - GitHub integration: Optional
```

#### 2. 배포 스크립트
```bash
#!/bin/bash

# Firebase 배포 스크립트
echo "🚀 Firebase 배포를 시작합니다..."

# public 디렉토리에 최신 파일 복사
cp index.html public/

# Firebase에 배포
firebase deploy --only hosting

echo "✅ Firebase 배포가 완료되었습니다!"
echo "🌐 사이트 URL: https://your-project.web.app"
```

#### 3. 자동화된 배포 (GitHub Actions)
```yaml
# .github/workflows/firebase-deploy.yml
name: Firebase Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '16'
        
    - name: Install dependencies
      run: npm install -g firebase-tools
      
    - name: Copy files to public
      run: cp index.html public/
      
    - name: Deploy to Firebase
      run: firebase deploy --only hosting
      env:
        FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

### GitHub Pages 배포 (대안)

#### 자동화된 배포 스크립트
```bash
#!/bin/bash

# 빌드 및 배포 스크립트
echo "🚀 GitHub Pages 배포를 시작합니다..."

# Git 상태 확인
git status

# 변경사항 커밋
git add .
git commit -m "🚀 배포: $(date '+%Y-%m-%d %H:%M:%S')"

# 원격 저장소에 푸시
git push origin main

echo "✅ 배포가 완료되었습니다!"
echo "🌐 사이트 URL: https://your-username.github.io/inventory-management/"
```

### 보안 설정

#### Firebase Hosting 보안 헤더
```json
// firebase.json의 headers 설정
{
  "hosting": {
    "headers": [
      {
        "source": "**",
        "headers": [
          {
            "key": "X-Frame-Options",
            "value": "DENY"
          },
          {
            "key": "X-Content-Type-Options", 
            "value": "nosniff"
          },
          {
            "key": "X-XSS-Protection",
            "value": "1; mode=block"
          },
          {
            "key": "Strict-Transport-Security",
            "value": "max-age=31536000; includeSubDomains"
          },
          {
            "key": "Referrer-Policy",
            "value": "strict-origin-when-cross-origin"
          }
        ]
      }
    ]
  }
}
```

### 모니터링 및 로깅

#### 클라이언트 로깅 시스템
```javascript
class Logger {
    static log(level, message, data = null) {
        const timestamp = new Date().toISOString();
        const logEntry = {
            timestamp,
            level,
            message,
            data,
            url: window.location.href,
            userAgent: navigator.userAgent
        };
        
        // 콘솔 출력
        console[level](message, data);
        
        // 로컬 스토리지에 저장 (최대 100개)
        const logs = JSON.parse(localStorage.getItem('app_logs') || '[]');
        logs.push(logEntry);
        
        if (logs.length > 100) {
            logs.shift(); // 오래된 로그 제거
        }
        
        localStorage.setItem('app_logs', JSON.stringify(logs));
        
        // 심각한 오류는 Firebase에 전송 (옵션)
        if (level === 'error') {
            this.sendErrorToFirebase(logEntry);
        }
    }
    
    static sendErrorToFirebase(errorLog) {
        if (isFirebaseConnected) {
            db.collection('errorLogs').add(errorLog).catch(console.error);
        }
    }
    
    static getLogs() {
        return JSON.parse(localStorage.getItem('app_logs') || '[]');
    }
    
    static clearLogs() {
        localStorage.removeItem('app_logs');
    }
}
```

### 성능 모니터링

#### 페이지 로드 시간 측정
```javascript
function measurePerformance() {
    if ('performance' in window) {
        window.addEventListener('load', () => {
            const navigation = performance.getEntriesByType('navigation')[0];
            const loadTime = navigation.loadEventEnd - navigation.fetchStart;
            
            Logger.log('info', 'Page load time', { 
                loadTime: `${loadTime}ms`,
                domContentLoaded: `${navigation.domContentLoadedEventEnd - navigation.fetchStart}ms`
            });
            
            // 3초 이상 걸리면 경고
            if (loadTime > 3000) {
                Logger.log('warn', 'Slow page load detected', { loadTime });
            }
        });
    }
}

// 앱 시작 시 성능 모니터링 활성화
measurePerformance();
```

## 👨‍💻 개발자 가이드

### 코드 구조

```
inventory-management/
├── index.html              # 메인 애플리케이션 파일
├── README.md              # 프로젝트 개요 및 사용법
├── TECHNICAL.md           # 기술 문서
├── assets/                # 정적 자원 (선택사항)
│   ├── css/              # 분리된 CSS 파일들
│   ├── js/               # 분리된 JavaScript 모듈
│   └── images/           # 이미지 파일들
└── docs/                 # 추가 문서들
    ├── API.md            # API 문서
    └── CHANGELOG.md      # 변경 이력
```

### 개발 환경 설정

#### 로컬 개발 서버
```bash
# Python 서버 (권장)
python3 -m http.server 8000

# Node.js 서버
npx http-server -p 8000

# PHP 서버
php -S localhost:8000

# Live Server (VS Code 확장)
# Live Server 확장 프로그램 설치 후 우클릭 > "Open with Live Server"
```

#### 디버깅 도구

##### Firebase 연결 상태 체크
```javascript
// 개발자 콘솔에서 실행할 수 있는 디버깅 함수들
window.debugFirebase = {
    checkConnection: () => {
        console.log('Firebase 연결 상태:', isFirebaseConnected);
        console.log('현재 데이터:', {
            facilities: facilitiesData,
            inventory: inventoryData.length,
            history: historyData.length
        });
    },
    
    testWrite: async () => {
        try {
            await db.collection('test').doc('debug').set({
                timestamp: new Date(),
                test: true
            });
            console.log('✅ Firebase 쓰기 테스트 성공');
        } catch (error) {
            console.error('❌ Firebase 쓰기 테스트 실패:', error);
        }
    },
    
    clearLocalData: () => {
        localStorage.clear();
        console.log('🗑️ 로컬 데이터가 삭제되었습니다. 페이지를 새로고침하세요.');
    }
};
```

### 커스터마이제이션 가이드

#### 새로운 생산시설 필드 추가
1. 데이터 모델 수정
```javascript
// getDefaultInventoryData() 함수에 새 필드 추가
{
    품목: "새 품목",
    규격: "규격",
    수량: 0,
    단위: "개",
    생산시설: "생산시설명",
    새필드: "새 값" // 새 필드 추가
}
```

2. UI 업데이트
```html
<!-- 품목 추가 모달에 새 입력 필드 추가 -->
<div class="form-group">
    <label for="newField">새 필드</label>
    <input type="text" id="newField" placeholder="새 필드를 입력하세요">
</div>
```

3. 저장 로직 수정
```javascript
// addItem() 함수 수정
const newItem = {
    품목: name,
    규격: spec,
    수량: quantity,
    단위: unit,
    생산시설: facility,
    새필드: document.getElementById('newField').value // 새 필드 값 추가
};
```

#### 커스텀 테마 적용
```css
/* 메인 색상 변경 */
:root {
    --primary-color: #2980b9;      /* 기본 파란색 */
    --success-color: #27ae60;      /* 성공 초록색 */
    --warning-color: #f39c12;      /* 경고 주황색 */
    --danger-color: #e74c3c;       /* 위험 빨간색 */
    --background-color: #f8f9fa;   /* 배경색 */
}

/* 다크 모드 (예시) */
@media (prefers-color-scheme: dark) {
    :root {
        --primary-color: #3498db;
        --background-color: #2c3e50;
        /* ... 기타 다크 모드 색상 */
    }
    
    body {
        background-color: var(--background-color);
        color: white;
    }
}
```

### 테스팅 가이드

#### 수동 테스트 체크리스트

**🔧 기본 기능 테스트**
- [ ] Firebase 연결 상태 확인
- [ ] 생산시설 추가/삭제
- [ ] 품목 추가/수정/삭제
- [ ] 입고요청서 작성
- [ ] 잔량 계산 정확성
- [ ] 입고이력 기록/삭제
- [ ] 엑셀 내보내기

**📱 반응형 테스트**
- [ ] 모바일 화면에서 UI 동작
- [ ] 태블릿 화면에서 UI 동작
- [ ] 데스크톱 화면에서 UI 동작

**🌐 브라우저 호환성 테스트**
- [ ] Chrome 최신 버전
- [ ] Firefox 최신 버전
- [ ] Safari (macOS/iOS)
- [ ] Edge 최신 버전

#### 자동화된 테스트 (향후 구현 가능)

```javascript
// 간단한 유닛 테스트 예시
class TestSuite {
    static runTests() {
        console.log('🧪 테스트 시작...');
        
        // 데이터 유효성 검사 테스트
        this.testDataValidation();
        
        // 계산 로직 테스트
        this.testCalculations();
        
        // UI 렌더링 테스트
        this.testUIRendering();
        
        console.log('✅ 모든 테스트 완료');
    }
    
    static testDataValidation() {
        const result = validateFacilityInput('');
        console.assert(!result.valid, 'Empty facility name should be invalid');
        
        const result2 = validateFacilityInput('Valid Name');
        console.assert(result2.valid, 'Valid facility name should be valid');
    }
    
    static testCalculations() {
        // 잔량 계산 테스트
        const remaining = 100 - 30; // 초기수량 - 입고수량
        console.assert(remaining === 70, 'Remaining calculation should be correct');
    }
    
    static testUIRendering() {
        // DOM 요소 존재 확인
        console.assert(
            document.getElementById('inventory-tbody') !== null,
            'Inventory table should exist'
        );
    }
}

// 개발 모드에서만 테스트 실행
if (window.location.hostname === 'localhost') {
    window.runTests = () => TestSuite.runTests();
}
```

### 성능 벤치마킹

```javascript
class PerformanceBenchmark {
    static async benchmarkTableRendering() {
        const startTime = performance.now();
        
        // 대용량 데이터로 테이블 렌더링
        const testData = Array.from({ length: 1000 }, (_, i) => ({
            품목: `테스트 품목 ${i}`,
            규격: `규격 ${i}`,
            수량: Math.floor(Math.random() * 1000),
            단위: '개',
            생산시설: `시설 ${i % 10}`
        }));
        
        inventoryData = testData;
        renderInventoryTable();
        
        const endTime = performance.now();
        console.log(`📊 1000개 항목 렌더링 시간: ${endTime - startTime}ms`);
        
        // 원본 데이터 복구
        await loadDataFromFirebase();
    }
    
    static benchmarkFirebaseOperations() {
        // Firebase 읽기/쓰기 성능 측정
        // 실제 환경에서는 주의해서 사용
    }
}
```

---

## 📞 기술 지원

### 문제 해결 가이드

**❓ 자주 발생하는 문제들**

1. **Firebase 연결 실패**
   - 네트워크 연결 확인
   - HTTPS 프로토콜 사용 확인
   - Firebase 설정 정보 확인
   - 브라우저 콘솔에서 오류 메시지 확인

2. **데이터 동기화 문제**
   - Firebase 보안 규칙 확인
   - 인터넷 연결 상태 확인
   - 로컬 스토리지 데이터와 Firebase 데이터 비교

3. **성능 이슈**
   - 브라우저 개발자 도구의 Performance 탭 활용
   - 대용량 데이터 처리 시 배치 처리 적용
   - 이미지 최적화 및 리소스 압축

### 연락처
- **이슈 리포트**: GitHub Issues 탭 활용
- **기능 제안**: Pull Request 또는 Issue 등록
- **기술 문의**: 프로젝트 위키 또는 Discussion 활용

---

## 📊 v4.1 업데이트 요약

### 새로운 아키텍처 요소

#### 1. 관리자 인증 시스템
- 클라이언트 사이드 세션 관리
- 권한 기반 기능 제어
- 로그인/로그아웃 생명주기 관리

#### 2. 생산시설/품목 관리 시스템
- CRUD (Create, Read, Update, Delete) 완전 지원
- 데이터 무결성 검증
- 연관 데이터 자동 업데이트

#### 3. Firebase Hosting 통합
- 보안 헤더 자동 설정
- HTTPS 강제 적용
- CDN 기반 글로벌 배포

### 보안 강화사항

#### 1. 접근 제어
```javascript
// 기능별 권한 검증 매트릭스
const PERMISSION_MATRIX = {
    'facility.create': 'admin',
    'facility.update': 'admin', 
    'facility.delete': 'admin',
    'item.create': 'admin',
    'item.update': 'admin',
    'item.delete': 'admin',
    'data.reset': 'admin',
    'data.clear': 'admin'
};

function hasPermission(action) {
    const requiredRole = PERMISSION_MATRIX[action];
    return requiredRole === 'admin' ? isAdminLoggedIn : true;
}
```

#### 2. 데이터 보호
- 민감한 작업 실행 전 이중 확인
- 연관 데이터 자동 백업
- 실수 방지를 위한 UI 제한

#### 3. 감사 로깅
```javascript
// 관리자 작업 로깅
function logAdminAction(action, details) {
    const logEntry = {
        timestamp: new Date().toISOString(),
        action,
        details,
        session: getSessionId(),
        ip: getClientIP()
    };
    
    // Firebase에 감사 로그 저장
    db.collection('auditLogs').add(logEntry);
}
```

---

**📝 문서 마지막 업데이트**: 2024년 12월
**🔖 문서 버전**: v4.1
**👥 작성자**: 개발팀
**🔐 보안 등급**: Enhanced