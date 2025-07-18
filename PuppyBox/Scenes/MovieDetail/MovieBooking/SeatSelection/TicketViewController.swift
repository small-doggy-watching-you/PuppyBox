//
//  TicketViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/19/25.
//

import UIKit

final class TicketViewController: UIViewController {
    private let movie: MovieResults
    private let seats: [String]
    private let date: Date?
    private let time: String?
    
    init(movie: MovieResults, seats: [String], date: Date?, time: String?) {
        self.movie = movie
        self.seats = seats
        self.date = date
        self.time = time
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "예매 완료"
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = """
        영화: \(movie.title)
        시간: \(time ?? "")
        좌석: \(seats.joined(separator: ", "))
        """
        
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}
