
import UIKit

import SnapKit
import Then
@available(iOS 17.0, *)

#Preview {
    UINavigationController(rootViewController: MyPageViewController())
}

class MyPageViewController: UIViewController {
    
    // navigationItem에 세팅
    
    //UIBarButtonItem 안에 커스텀 뷰 안에 버튼을 넣어준다.
    private let logoutButton = UIButton(configuration: .filled()).then {
        $0.configuration?.title = "로그아웃"
        $0.tintColor = .appPrimary
        $0.configuration?.background.cornerRadius = 10
        
    }
    
    private let navCustomView = UIView()
    
    // String만 올림
    private let myPageLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    // UIBarButtonItem으로 변경
    private let settingSymbol = UIButton(configuration: .plain()).then {
        
        $0.configuration?.image = UIImage(systemName: "gearshape")
        $0.tintColor = .label
    }
    
    // ------------------
    
    private let reservedMovieLabel = UILabel().then {
        $0.text = "예매중인 영화"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    private let historyLabel = UILabel().then {
        $0.text = "관람 기록"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    private let moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.systemGray3, for: .normal)
        $0.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dummy = UserDummyData()
        let viewModel = MyPageViewModel(userData: dummy.sampleUser)
        configureUI()
        
    }
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        navCustomView.addSubview(logoutButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.titleView = myPageLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingSymbol)
        
    }
    /*
     1. 사용할 목데이터 제작 O
     
     2. UICollectionViewCompositionalLayout으로 레이아웃 설정
     
     2-1 section
     2-2 group
     
     이거부터 -> 3. UICollectionViewDiffableDataSource<Section, Item>{}로 데이터소스를 만든다.
     
     3-1 셀정보 어떤 아이템을 넣을것인지
     UICollectionView.CellRegistration<셀, 타입? 개인정보 VC에서만 쓰는 타입을 만든다.>
    
     3-2
     dequeueConfiguredReusableCell 주입
     
     supplementaryViewProvider 헤더 생성
     
     + 라벨과 버튼은 헤더용 새로운 뷰에 넣고 사용 UICollectionReusableView
     
     
     */
}
