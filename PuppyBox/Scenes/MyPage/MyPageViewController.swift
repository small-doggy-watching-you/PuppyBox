
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
    
    var isExpanded = false
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    lazy var collectionViewDataSource = makeDataSource(collectionView)
    
    init() {
        viewModel = MyPageViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.action(.fetchUserData)
        
        viewModel.onStateChanged = { [weak self] _ in
            guard let self else { return }
            updateDataSorce()
        }
        
        logoutButton.addAction(UIAction { [weak self] _ in
            guard self != nil else { return }
            //신 딜리게이트 이동 방식
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                
                UIView.transition(with: sceneDelegate.window!,
                                  duration: 0.4,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                    sceneDelegate.window?.rootViewController = navController
                },
                                  completion: nil)
            }
            
        }, for: .touchUpInside)
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
        collectionView.register(MyPageSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        updateDataSorce()
    }
    
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        // 셀 정의
        let userCellRegistration = UICollectionView.CellRegistration<UserInfoCell, UserInfo> { cell, _, userInfo in
            cell.configure(with: userInfo)
        }
        
        let movieCellRegistration = UICollectionView.CellRegistration<MovieCell, MyMovie> { cell, _, movie in
            cell.configure(with: movie)
        }
        
        // 컬렉션 뷰에서 어떤 셀을 가져와서 사용할지 정의
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .userInfo(userInfo):
                collectionView.dequeueConfiguredReusableCell(using: userCellRegistration, for: indexPath, item: userInfo)
            case let .reservedMovie(movie), let .histories(movie):
                collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration, for: indexPath, item: movie)
            }
        }
        
        // 섹션에 들어갈 뷰에 대한 정의
        dataSource.supplementaryViewProvider = { [weak dataSource] collectionView, kind, indexPath in
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else { return nil }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! MyPageSectionHeaderView
            
            switch section {
            case .reservedMovie:
                headerView.titleLabel.text = "예매중인 영화"
                headerView.moreButton.isHidden = true
            case .histories:
                headerView.titleLabel.text = "관람 기록"
            default:
                break
            }
            
            headerView.onTapMoreButton = { [weak self] in
                guard let self else { return }
                self.isExpanded.toggle()
                self.updateDataSorce()
                if isExpanded {
                    headerView.moreButton.configuration?.title = "접기"
                    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .bold)
                    headerView.moreButton.configuration?.image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
                } else {
                    headerView.moreButton.configuration?.title = "더보기"
                    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .bold)
                    headerView.moreButton.configuration?.image = UIImage(systemName: "chevron.forward", withConfiguration: symbolConfig)
                }
            }
            return headerView
        }
        return dataSource
    }
    
    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
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
                        heightDimension: .absolute(200)
                    ),
                    subitems: [layoutItem]
                )
                
                let section = NSCollectionLayoutSection(group: layoutGroup)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 70, trailing: 0)
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
                    alignment: .top // 셀보다 위로
                )
                
                let section = NSCollectionLayoutSection(group: layoutGroup)
                section.boundarySupplementaryItems = [boundaryItem]
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 33, trailing: 16)
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
        
        let reservedMovie = userData.reservedMovies
        let histories = userData.watchedMovies
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections([.userInfo])
        snapShot.appendItems([.userInfo(userInfo)], toSection: .userInfo)
        snapShot.appendSections([.reservedMovie])
        snapShot.appendItems(reservedMovie.map { .reservedMovie($0) }, toSection: .reservedMovie)
        if isExpanded {
            snapShot.appendSections([.histories])
            snapShot.appendItems(histories.map { .histories($0) }, toSection: .histories)
        } else {
            snapShot.appendSections([.histories])
            snapShot.appendItems(histories.prefix(3).map { .histories($0) }, toSection: .histories)
        }
        collectionViewDataSource.apply(snapShot)
    }
    
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
