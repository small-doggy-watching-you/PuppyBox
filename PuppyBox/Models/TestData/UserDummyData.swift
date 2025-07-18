
struct UserDummyData {
    var sampleUser: UserData{
        return UserData(
            nickname: "테스트 유저",
            userId: "테스트유저1",
            email: "exapmle@example.com",
            profileImageUrl: "defaultProfile",
            reservedMovie: dummyReservedMovies,
            seenMovie: dummySeenMovies
        )
    }
    
    let dummyReservedMovies = [
        MyMovie(
            movieId:1,
            movieName: "가라데 키드: 레전드",
            posterImagePath: "https://image.tmdb.org/t/p/w92/AEgggzRr1vZCLY86MAp93li43z.jpg",
            seenDate: nil,
            reservedDate: "2025-07-23 19:30"
        ),
        MyMovie(
            movieId:2,
            movieName: "발레리나",
            posterImagePath: "https://image.tmdb.org/t/p/w92/f9iSnN9yiedMgjGX4wQnHk3GZpB.jpg",
            seenDate: nil,
            reservedDate: "2025-07-23 23:30"
        ),
        MyMovie(
            movieId:3,
            movieName: "쥬라기 월드: 새로운 시작",
            posterImagePath: "https://image.tmdb.org/t/p/w92/ygr4hE8Qpagv8sxZbMw1mtYkcQE.jpg",
            seenDate: nil,
            reservedDate: "2025-07-24 11:30"
        ),
//        MyMovie(
//            movieId:4,
//            movieName: "브링 허 백",
//            posterImagePath: "https://image.tmdb.org/t/p/w92/A4W0yRN7Xy6JLIhRymIh5plK2Zj.jpg",
//            seenDate: nil,
//            reservedDate: "2025-07-24 19:30"
//        ),
    ]

    let dummySeenMovies = [
        MyMovie(
            movieId:5,
            movieName: "리추얼",
            posterImagePath: "https://image.tmdb.org/t/p/w92/ktqPs5QyuF8SpKnipvVHb3fwD8d.jpg",
            seenDate: nil,
            reservedDate: "2025-07-22 19:30"
        ),
        MyMovie(
            movieId:6,
            movieName: "판타스틱 4: 새로운 출발",
            posterImagePath: "https://image.tmdb.org/t/p/w92/sHgIQvDlk5188wo9jM8IKFeyJUd.jpg",
            seenDate: nil,
            reservedDate: "2025-07-21 19:30"
        ),
        MyMovie(
            movieId:7,
            movieName: "인 더 로스트 랜즈",
            posterImagePath: "https://image.tmdb.org/t/p/w92/dDlfjR7gllmr8HTeN6rfrYhTdwX.jpg",
            seenDate: nil,
            reservedDate: "2025-07-20 19:30"
        ),
        MyMovie(
            movieId:8,
            movieName: "페니키안 스킴",
            posterImagePath: "https://image.tmdb.org/t/p/w92/ozh99jSatJKBG9OVN9x3XYBYBRN.jpg",
            seenDate: nil,
            reservedDate: "2025-07-19 19:30"
        ),
        MyMovie(
            movieId:9,
            movieName: "스머프",
            posterImagePath: "https://image.tmdb.org/t/p/w92/1lQHA18T32JyIonQUkSWhMwinjm.jpg",
            seenDate: nil,
            reservedDate: "2025-07-18 19:30"
        ),
        MyMovie(
            movieId:10,
            movieName: "플라이트 리스크",
            posterImagePath: "https://image.tmdb.org/t/p/w92/zstC9sgsPaV98TaZtHL6aTtBUtB.jpg",
            seenDate: nil,
            reservedDate: "2025-07-17 19:30"
        ),
    ]
}


