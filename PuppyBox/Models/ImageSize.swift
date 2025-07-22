
// API로 수신받는 이미지 사이즈 enum
enum ImageSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original

    var description: String {
        return rawValue
    }
}
