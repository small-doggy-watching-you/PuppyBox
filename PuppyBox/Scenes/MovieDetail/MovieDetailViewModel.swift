//
//  MovieDetailViewModel.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import Foundation

final class MovieDetailViewModel: ViewModelProtocol {
    
    struct State {
        var movie: MovieResults? = nil
        var selectedDate: Date? = nil
        var selectedTime: String? = nil
        var adultCount: Int = 0
        var childCount: Int = 0
    }
    
    private(set) var state: State {
        didSet { onStateChanged?(state) }
    }
    
    private let movieResult = MovieResults(adult: false, backdropPath: "/nKyBbFSooRPTJVqjrDteD1lF733.jpg", genreIds: [28, 12, 18], id: 1011477, originalLanguage: "en", originalTitle: "Karate Kid: Legends", overview: "서로 다른 세대의 스승 미스터 한(성룡)과 다니엘 라루소(랄프 마치오)가 소년 '리'를 중심으로 힘을 합치며 펼쳐지는 무술 성장 드라마. 과거의 철학과 기술을 계승한 두 사부는 삶의 벽에 부딪힌 리에게 가라데의 진정한 의미를 전하며 함께 성장한다.", popularity: 629.7943, posterPath: "/AEgggzRr1vZCLY86MAp93li43z.jpg", releaseDate: "2025-05-08", title: "가라데 키드: 레전드", video: false, voteAverage: 7.319, voteCount: 408)
    
    var onStateChanged: ((State) -> Void)?
    
    init() {
        state = State()
    }
    
    enum Action {
        case configure(MovieResults)
        case changeAdultCount(Int)
        case changeChildCount(Int)
        case selectTime(String)
        case selectDate(Date)
    }
    
    func action(_ action: Action) {
        switch action {
        case .configure(let movie):
            state.movie = movie
        case .changeAdultCount(let count):
            state.adultCount = max(0, state.adultCount + count)
        case .changeChildCount(let count):
            state.childCount = max(0, state.childCount + count)
        case .selectTime(let time):
            state.selectedTime = time
        case .selectDate(let date):
            state.selectedDate = date
        }
    }
}


/*
 {
   "change_keys": [
     "adult",
     "air_date",
     "also_known_as",
     "alternative_titles",
     "biography",
     "birthday",
     "budget",
     "cast",
     "certifications",
     "character_names",
     "created_by",
     "crew",
     "deathday",
     "episode",
     "episode_number",
     "episode_run_time",
     "freebase_id",
     "freebase_mid",
     "general",
     "genres",
     "guest_stars",
     "homepage",
     "images",
     "imdb_id",
     "languages",
     "name",
     "network",
     "origin_country",
     "original_name",
     "original_title",
     "overview",
     "parts",
     "place_of_birth",
     "plot_keywords",
     "production_code",
     "production_companies",
     "production_countries",
     "releases",
     "revenue",
     "runtime",
     "season",
     "season_number",
     "season_regular",
     "spoken_languages",
     "status",
     "tagline",
     "title",
     "translations",
     "tvdb_id",
     "tvrage_id",
     "type",
     "video",
     "videos"
   ],
   "images": {
     "base_url": "http://image.tmdb.org/t/p/",
     "secure_base_url": "https://image.tmdb.org/t/p/",
     "backdrop_sizes": [
       "w300",
       "w780",
       "w1280",
       "original"
     ],
     "logo_sizes": [
       "w45",
       "w92",
       "w154",
       "w185",
       "w300",
       "w500",
       "original"
     ],
     "poster_sizes": [
       "w92",
       "w154",
       "w185",
       "w342",
       "w500",
       "w780",
       "original"
     ],
     "profile_sizes": [
       "w45",
       "w185",
       "h632",
       "original"
     ],
     "still_sizes": [
       "w92",
       "w185",
       "w300",
       "original"
     ]
   }
 }
 */
