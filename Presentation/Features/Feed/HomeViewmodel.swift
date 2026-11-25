//
//  HomeViewmodel.swift
//  instagram_clone
//
//  Created by Kalyani Mhase on 22/11/26.
//

final class HomeViewmodel {
    let users: [User] = [
        User(
            name: DataSource.currentUserName,
            address: "Wagholi, Pune, MH",
            mob_number: "9518352333",
            storyData: [
                StoryData(image: AppImages.person, isView: false, name: "Your story")
            ]
        ),
        User(
            name: "Tushar",
            address: "Airoli, Navi mumbai, MH",
            mob_number: "9168168012",
            storyData: [
                StoryData(image: AppImages.person, isView: false, name: "Tushar")
            ]
        )
    ]

    var storyData: [StoryData] {
        users.flatMap(\.storyData)
    }
}
