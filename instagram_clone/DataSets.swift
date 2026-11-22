//
//  DataSets.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//
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
}
enum sections {
    case story
    case posts
    
}
struct PostData {
    let user_name: String
    var isLike: Bool
    let likes_count: Int
    let likes: [Likes]
    let comments_count: Int
    let comments: [Comments]
    var isBookMark: Bool
    var posts: [String]//[Data]

}
struct Comments {
    let user_name: String
    let comment_msg: String
}
struct Likes {
    var count: Int
    var list_of_user: [String]
    
}
class DataSource {
    
    static var users = [
        PostData(user_name: "Kartik Mhase", isLike: true, likes_count: 10, likes: [Likes(count: 10, list_of_user: ["Shruti Pawar","Nidhi Agarwal","Pankaj Kale","Swati Kale","Shreya Patil","Mrunal Gade","Poonam Pandit","Anuj Pawar","Avinash Patare"])], comments_count: 4, comments: [Comments(user_name: "", comment_msg: "Congragulations Pallavi"),Comments(user_name: "Mayur Salave", comment_msg: "❤️❤️"),Comments(user_name: "Amit More", comment_msg: "Many Many Congradulations 😍")], isBookMark: false, posts: [AppImages.person]),
        PostData(user_name: "Kartik Mhase", isLike: false, likes_count: 10, likes: [Likes(count: 5, list_of_user: ["Shruti Pawar","Nidhi Agarwal","Pankaj Kale","Swati Kale","Shreya Patil","Mrunal Gade","Poonam Pandit","Anuj Pawar","Avinash Patare"])], comments_count: 10, comments: [Comments(user_name: "", comment_msg: "Congragulations Pallavi"),Comments(user_name: "Mayur Salave", comment_msg: "❤️❤️"),Comments(user_name: "Amit More", comment_msg: "Many Many Congradulations 😍")], isBookMark: false, posts: [AppImages.person]),
        PostData(user_name: "Kartik Mhase", isLike: true, likes_count: 10, likes: [Likes(count: 10, list_of_user: ["Shruti Pawar","Nidhi Agarwal","Pankaj Kale","Swati Kale","Shreya Patil","Mrunal Gade","Poonam Pandit","Anuj Pawar","Avinash Patare"])], comments_count: 12, comments: [Comments(user_name: "", comment_msg: "Congragulations Pallavi"),Comments(user_name: "Mayur Salave", comment_msg: "❤️❤️"),Comments(user_name: "Amit More", comment_msg: "Many Many Congradulations 😍")], isBookMark: true, posts: [AppImages.person])
    ]
}

struct AppImages {
    static let bookmark_fill = "bookmark_fill"
    static let bookMark = "bookMark"
    static let comment = "comment"
    static let favourite = "favourite"
    static let send = "send"
    static let heart = "heart"
    static let home = "home"
    static let more = "more"
    static let person = "person"
    static let reel = "reel"
    static let search = "search"
    static let three_dot = "three_dot"
    static let user = "user"
    static let share = "share"
    
    
}
