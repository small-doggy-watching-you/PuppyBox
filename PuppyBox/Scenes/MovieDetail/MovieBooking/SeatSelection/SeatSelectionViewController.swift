//
//  SeatSelectionViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import UIKit

final class SeatSelectionViewController: UIViewController {
    private let movie: MovieResults
    private let selectedDate: Date?
    private let selectedTime: String?
    private let adultCount: Int
    private let childCount: Int

    init(movie: MovieResults,
         selectedDate: Date?,
         selectedTime: String?,
         adultCount: Int,
         childCount: Int) {
        self.movie = movie
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.adultCount = adultCount
        self.childCount = childCount
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "좌석 선택"
        print("영화: \(movie.title)")
        print("날짜: \(String(describing: selectedDate))")
        print("시간: \(String(describing: selectedTime))")
        print("어른: \(adultCount), 어린이: \(childCount)")
    }
}
