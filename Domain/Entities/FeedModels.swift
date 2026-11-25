import Foundation

struct User {
    let name: String?
    let address: String?
    let mob_number: String?
    var storyData: [StoryData]
}

struct StoryData {
    var image: String?
    var isView: Bool?
    var name: String = ""
}

struct PostData {
    let user_name: String
    var isLike: Bool
    let likes_count: Int
    let likes: [Likes]
    let comments_count: Int
    var comments: [Comments]
    var isBookMark: Bool
    var posts: [String]
}

struct Comments {
    let user_name: String
    let comment_msg: String
    var isLiked: Bool = false
    var likeCount: Int = 0
}

struct Likes {
    var count: Int
    var list_of_user: [String]
}
