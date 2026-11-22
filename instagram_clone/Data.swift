//
//  Data.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//

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
