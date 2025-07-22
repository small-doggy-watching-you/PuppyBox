
# 🎬 PuppyBox

PuppyBox는 사용자 친화적인 영화 예매 iOS 앱입니다.
Splash부터 로그인, 영화 검색 및 상세정보, 예매, 마이페이지 기능까지 직관적이고 유연한 사용자 흐름을 제공합니다.

---

## 📁 프로젝트 폴더 구조

```
📁 PuppyBox
├── 📁 App                 // AppDelegate 및 SceneDelegate 등 앱 진입점
├── 📁 Extensions          // UIKit/Swift 기본 타입 확장 (예: UIColor, Font)
├── 📁 Model
│   └── 📁 CoreData        // CoreData Entity 및 저장 관리 클래스
├── 📁 Protocols           // ViewModelProtocol  정의
├── 📁 Resources
│   └── 📁 Fonts           // 사용자 지정 폰트
├── 📁 Scenes              // 화면별 폴더 구조
│   ├── 📁 Login           // 로그인 화면
│   ├── 📁 MovieDetail     // 영화 상세 화면
│   │   ├── 📁 MovieBooking      // 예매 옵션 선택 UI
│   │   ├── 📁 MovieInfo         // 영화 정보 UI
│   │   ├── 📁 SeatSelection     // 좌석 선택 UI
│   │   └── 📁 Ticket            // 예매 티켓 결과 화면
│   ├── 📁 MovieList       // 무비차트 / 현재 상영작 / 예정작 리스트
│   ├── 📁 MyPage          // 사용자 정보, 예매 내역, 관람기록
│   ├── 📁 SignUp          // 회원가입 화면
│   └── 📁 Splash          // 앱 진입 초기 스플래시 비디오
└── 📁 Utils               // AlertFactory, ImagePathService 등 유틸리티
```

---

## 🛠 주요 기술 스택

* **MVVM 아키텍처** – ViewModel을 통한 상태 관리
* **CoreData** – 사용자 및 영화 정보 로컬 저장
* **DiffableDataSource + CompositionalLayout** – 컬렉션뷰 구성
* **UIKit**
* **SnapKit** – 오토레이아웃 구성
* **Then** – UI 구성 요소 간결화
* **Kingfisher** – 비동기 이미지 로딩 및 캐싱

---

## 💡 주요 기능 소개

### 🔥 Splash 화면

* `SplashViewController`
* 앱 실행 시 `PuppyBoxOpen.mp4` 영상 자동 재생 후 로그인 화면으로 전환

### 👤 로그인 & 회원가입

* `LoginViewController`, `SignUpViewController`
* `UserDefaults` 및 CoreData를 활용한 로그인 상태 유지
* 중복 확인, 유효성 검증, 회원가입 처리

### 🎞 영화 리스트

* `MovieListViewController`
* TMDB API 기반 실시간 무비차트 / 현재상영작 / 예정작 표시
* 섹션별 Compositional Layout 적용, 영화 선택 시 상세화면 이동

### 🔍 영화 검색

* `SearchViewController`
* 통합된 현재상영작 + 예정작 대상으로 제목 기반 실시간 검색
* 결과 목록을 컬렉션뷰로 표시

### 📄 영화 상세 & 예매

* `MovieDetailViewController`
* 영화 정보, 예매 옵션, 포스터 클릭 시 전체 보기 기능 포함
* 좌석 선택 및 예매 티켓 발급까지 연결

### 👤 마이페이지

* `MyPageViewController`
* 로그인한 유저의 프로필, 예매 내역, 관람 기록을 표시
* 관람 기록 펼치기/접기, 로그아웃 기능 포함

---

## 🧪 개발환경

* iOS 16 이상
* Xcode 15 이상
* Swift 5.9

---

## 🎨 와이어프레임
<img width="840" height="727" alt="스크린샷 2025-07-22 오전 11 09 58" src="https://github.com/user-attachments/assets/cf34c9c6-6c99-4c97-9724-d211ba4e499c" />
