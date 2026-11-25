import Foundation

enum DataSource {
    static let currentUserName = "Kalyani"

    static func isCurrentUser(_ name: String) -> Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
            .caseInsensitiveCompare(currentUserName) == .orderedSame
    }

    static var users = [
        PostData(
            user_name: "Kartik Mhase",
            isLike: true,
            likes_count: 10,
            likes: [Likes(count: 10, list_of_user: ["Shruti Pawar", "Nidhi Agarwal", "Pankaj Kale", "Swati Kale", "Shreya Patil", "Mrunal Gade", "Poonam Pandit", "Anuj Pawar", "Avinash Patare"])],
            comments_count: 4,
            comments: [Comments(user_name: "", comment_msg: "Congragulations Kalyani"), Comments(user_name: "Mayur Salave", comment_msg: "❤️❤️"), Comments(user_name: "Amit More", comment_msg: "Many Many Congradulations 😍")],
            isBookMark: false,
            posts: ["person"]
        ),
        PostData(
            user_name: "Kartik Mhase",
            isLike: false,
            likes_count: 10,
            likes: [Likes(count: 5, list_of_user: ["Shruti Pawar", "Nidhi Agarwal", "Pankaj Kale", "Swati Kale", "Shreya Patil", "Mrunal Gade", "Poonam Pandit", "Anuj Pawar", "Avinash Patare"])],
            comments_count: 10,
            comments: [Comments(user_name: "", comment_msg: "Congragulations Kalyani"), Comments(user_name: "Mayur Salave", comment_msg: "❤️❤️"), Comments(user_name: "Amit More", comment_msg: "Many Many Congradulations 😍")],
            isBookMark: false,
            posts: ["person"]
        ),
        PostData(
            user_name: "Kartik Mhase",
            isLike: true,
            likes_count: 10,
            likes: [Likes(count: 10, list_of_user: ["Shruti Pawar", "Nidhi Agarwal", "Pankaj Kale", "Swati Kale", "Shreya Patil", "Mrunal Gade", "Poonam Pandit", "Anuj Pawar", "Avinash Patare"])],
            comments_count: 12,
            comments: [Comments(user_name: "", comment_msg: "Congragulations Kalyani"), Comments(user_name: "Mayur Salave", comment_msg: "❤️❤️"), Comments(user_name: "Amit More", comment_msg: "Many Many Congradulations 😍")],
            isBookMark: true,
            posts: ["person"]
        )
    ]
}
