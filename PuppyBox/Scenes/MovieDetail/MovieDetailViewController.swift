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

class MovieDetailViewController: UIViewController {
    private let movieDetailView = MovieDetailView()
    private let viewModel: MovieDetailViewModel
    
    init(movie: MovieResults) {
        self.viewModel = MovieDetailViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        bindViewModel()
        bindActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.tintColor = .init()
    }
    
    private func setupView() {
        view.addSubview(movieDetailView)
        movieDetailView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self, let movie = state.movie else { return }
            self.movieDetailView.configure(with: movie)
            self.loadPosterImage(posterPath: movie.posterPath)
        }
    }
    
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
            
            let seatVC = SeatSelectionViewController(movie: movie, selectedDate: date, selectedTime: time, adultCount: adult, childCount: child)
            self.navigationController?.pushViewController(seatVC, animated: true)
        }
    }
    
    func configure(with movie: MovieResults) {
        viewModel.action(.configure(movie))
    }
    
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
        
        // Kingfisher를 사용한 비동기 로딩
        movieDetailView.setPosterImage(nil) // placeholder
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.1)), // 부드러운 페이드인
            .cacheOriginalImage
        ]
        movieDetailView.kfSetPosterImage(with: url, options: options)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonDisplayMode = .minimal // 뒤로가기 텍스트 제거
        navigationController?.navigationBar.tintColor = .white // 뒤로가기 버튼 색 <- 문제가 생길 수 있음
        navigationItem.largeTitleDisplayMode = .never // 이거 나중에 확인
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // 상태바(시간, 배터리) 흰색
    }
}

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

// #Preview로 보기
@available(iOS 17.0, *)
#Preview {
    MovieDetailViewController(movie: MovieResults(adult: false, backdropPath: "/nKyBbFSooRPTJVqjrDteD1lF733.jpg", genreIds: [28, 12, 18], id: 1011477, originalLanguage: "en", originalTitle: "Karate Kid: Legends", overview: "서로 다른 세대의 스승 미스터 한(성룡)과 다니엘 라루소(랄프 마치오)가 소년 '리'를 중심으로 힘을 합치며 펼쳐지는 무술 성장 드라마. 과거의 철학과 기술을 계승한 두 사부는 삶의 벽에 부딪힌 리에게 가라데의 진정한 의미를 전하며 함께 성장한다.", popularity: 750.3586, posterPath: "/AEgggzRr1vZCLY86MAp93li43z.jpg", releaseDate: "2025-05-08", title: "가라데 키드: 레전드", video: false, voteAverage: 7.314, voteCount: 388))
}
