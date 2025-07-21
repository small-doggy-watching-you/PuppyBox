//
//  MovieDetailViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

// MARK: - 영화 상세 화면 컨트롤러

class MovieDetailViewController: UIViewController {
    // MARK: - 프로퍼티

    private let movieDetailView = MovieDetailView()
    private let viewModel: MovieDetailViewModel
    
    private let topGradientMaskView = GradientView().then {
        $0.colors = [UIColor.black, UIColor.clear]
        $0.locations = [0.0, 1.0]
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - 초기화

    init(movie: MovieResults) {
        self.viewModel = MovieDetailViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true // push 시 하단 탭바 숨김
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 라이프사이클

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        bindViewModel()
        bindActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 필요 시 네비게이션 바 관련 처리
    }
    
    // MARK: - UI 세팅

    private func setupView() {
        view.addSubview(movieDetailView)
        view.addSubview(topGradientMaskView)
        
        movieDetailView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        topGradientMaskView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    // MARK: - 네비게이션 바 세팅

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonDisplayMode = .minimal // 뒤로가기 텍스트 제거
        navigationController?.navigationBar.tintColor = .white // 뒤로가기 버튼 색상
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - ViewModel 바인딩

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self, let movie = state.movie else { return }
            self.movieDetailView.configure(with: movie)
            self.loadPosterImage(posterPath: movie.posterPath)
        }
    }
    
    // MARK: - 액션 바인딩

    private func bindActions() {
        movieDetailView.onPosterTapped = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.presentFullScreenImage()
            }
        }
        
        movieDetailView.movieBookingView.onSelectSeat = { [weak self] date, time, adult, child in
            guard let self = self else { return }
            guard let movie = self.viewModel.state.movie else { return }
            
            // SeatSelection으로 이동
            let seatVC = SeatSelectionViewController(
                movie: movie,
                selectedDate: date,
                selectedTime: time,
                adultCount: adult,
                childCount: child
            )
            self.navigationController?.pushViewController(seatVC, animated: true)
        }
    }
    
    // MARK: - 외부에서 영화 정보 전달

    func configure(with movie: MovieResults) {
        viewModel.action(.configure(movie))
    }
    
    // MARK: - 포스터 이미지 로딩

    private func loadPosterImage(posterPath: String?) {
        guard let posterPath = posterPath else {
            movieDetailView.setPosterImage(nil)
            return
        }
        let urlString = ImagePathService.makeImagePath(size: ImageSize.w780.rawValue, posterPath: posterPath)
        guard let url = URL(string: urlString) else {
            movieDetailView.setPosterImage(nil)
            return
        }
        
        movieDetailView.setPosterImage(nil) // placeholder
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.1)),
            .cacheOriginalImage
        ]
        movieDetailView.kfSetPosterImage(with: url, options: options)
    }
    
    // MARK: - 상태바 스타일

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - 풀스크린 이미지 표시

extension MovieDetailViewController {
    @MainActor
    func presentFullScreenImage() async {
        guard let currentImage = movieDetailView.posterImage else { return }
        
        let overlay = FullScreenImageOverlayView(image: currentImage) {
            print("Overlay dismissed")
        }
        view.addSubview(overlay)
        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
