
import UIKit

import SnapKit
import Then
@available(iOS 17.0, *)

#Preview {
    UINavigationController(rootViewController: MyPageViewController())
}

class MyPageViewController: UIViewController {
    
    private let viewModel: MyPageViewModel
    
    private let logoutButton = UIButton(configuration: .filled()).then {
        $0.configuration?.title = "로그아웃"
        $0.tintColor = .appPrimary
        $0.configuration?.background.cornerRadius = 10
        
    }
    
    private let navCustomView = UIView()
    
    
    private let myPageLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    private let settingSymbol = UIButton(configuration: .plain()).then {
        
        $0.configuration?.image = UIImage(systemName: "gearshape")
        $0.tintColor = .label
    }
    
    // ------------------
    
    lazy var collectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    lazy var collectionViewDataSource = makeDataSource(collectionView)
    
    init(){
        let dummy = UserDummyData()
        viewModel = MyPageViewModel(userData: dummy.sampleUser)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
        viewModel.onStateChanged = { [weak self] _ in
            guard self != nil else { return }
            print("updated")
            
        }
        
    }
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        navCustomView.addSubview(logoutButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.titleView = myPageLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingSymbol)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        // 섹션 정의할 거 등록
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        updateDataSorce()
        
    }
    
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item>{
        // 셀 정의
        let userCellRegistration = UICollectionView.CellRegistration<UserInfoCell, UserInfo> { cell, indexPath, userInfo in
            cell.configure(with: userInfo)
        }
        
        let movieCellRegistration = UICollectionView.CellRegistration<MovieCell, MyMovie> { cell, indexPath, movie in
            //            cell.configure(with: movie)
        }
        
        // 컬렉션 뷰에서 어떤 셀을 가져와서 사용할지 정의
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .userInfo(let userInfo):
                collectionView.dequeueConfiguredReusableCell(using: userCellRegistration, for: indexPath, item: userInfo)
            case .reservedMovie(let movie), .histories(let movie):
                collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration, for: indexPath, item: movie)
            }
        }
        
        // 섹션에 들어갈 뷰에 대한 정의
        dataSource.supplementaryViewProvider = { [weak dataSource] collectionView, kind, indexPath in
           
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else { return nil }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! SectionHeaderView
            
            switch section {
            case .reservedMovie:
                headerView.titleLabel.text = "예약중인 영화" // 더보기 버튼 히든 여기
            case .histories:
                headerView.titleLabel.text = "관람 기록"
            default :
                break
            }
            return headerView
        }
        return dataSource
    }
    
    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let section = self?.collectionViewDataSource.sectionIdentifier(for: sectionIndex) else { return nil }
            
            switch section {
            case .userInfo:
                let layoutItem = NSCollectionLayoutItem( // 하나의 셀
                  layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                  )
                )
                let layoutGroup = NSCollectionLayoutGroup.horizontal( // 셀을 담을 공간
                  layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(300)
                  ),
                  subitems: [layoutItem]
                )
                
                let section = NSCollectionLayoutSection(group: layoutGroup)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                return section
                
            case .reservedMovie, .histories:
                let layoutItem = NSCollectionLayoutItem(
                  layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                  )
                )
                let layoutGroup = NSCollectionLayoutGroup.horizontal(
                  layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(72)
                  ),
                  subitems: [layoutItem]
                )
                // boundaryItem 섹션마다 붙는 것
                let boundaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(50)
                  ),
                  elementKind: UICollectionView.elementKindSectionHeader,
                  alignment: .top //셀보다 위로
                )
                
                let section = NSCollectionLayoutSection(group: layoutGroup)
                section.boundarySupplementaryItems = [boundaryItem]
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                return section
            }
        }
        
    }
    
    func updateDataSorce() {
        let userData = viewModel.state.userData
        let userInfo = UserInfo(
            nickname: userData.nickname,
            userId: userData.userId,
            email: userData.email,
            profileImagePath: userData.profileImageUrl
        )
        
        let reservedMovie = userData.reservedMovie
        let histories = userData.seenMovie
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections([.userInfo])
        snapShot.appendItems([.userInfo(userInfo)], toSection: .userInfo)
        snapShot.appendSections([.reservedMovie])
        snapShot.appendItems(reservedMovie.map{ .reservedMovie($0)}, toSection: .reservedMovie)
        snapShot.appendSections([.histories])
        snapShot.appendItems(histories.map{ .histories($0)}, toSection: .histories)
        collectionViewDataSource.apply(snapShot)
        
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
    
    // 섹션 종류
    enum Section {
        case userInfo
        case reservedMovie
        case histories
    }
    
    // 아이템 종류
    enum Item: Hashable {
        case userInfo(UserInfo)
        case reservedMovie(MyMovie)
        case histories(MyMovie)
    }
    
}
