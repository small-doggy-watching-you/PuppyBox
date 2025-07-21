//
//  TicketViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/19/25.
//

import UIKit

// MARK: - 예매 완료 화면 컨트롤러

final class TicketViewController: UIViewController {
    // MARK: - 프로퍼티

    private let movie: MovieResults
    private let seats: [String]
    private let date: Date?
    private let time: String?
    
    // MARK: - 초기화

    init(movie: MovieResults, seats: [String], date: Date?, time: String?) {
        self.movie = movie
        self.seats = seats
        self.date = date
        self.time = time
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - 라이프사이클

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "예매 완료"
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = """
        영화: \(movie.title)
        시간: \(time ?? "")
        좌석: \(seats.joined(separator: ", "))
        """
        
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
        
        setupNavigationBar()
    }
    
    // MARK: - 네비게이션 바 세팅

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .black
        appearance.backgroundEffect = nil
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonDisplayMode = .minimal // 뒤로가기 텍스트 제거
        navigationController?.navigationBar.tintColor = .white // 뒤로가기 버튼 색상
        navigationItem.largeTitleDisplayMode = .never
    }
}
