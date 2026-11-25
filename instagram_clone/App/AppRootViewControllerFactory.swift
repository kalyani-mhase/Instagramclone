import UIKit

/// Composes the application's root navigation structure from presentation screens.
enum AppRootViewControllerFactory {
    static func makeTabBarController() -> UITabBarController? {
        guard let homeViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return nil
        }

        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let currentUser = User(
            name: DataSource.currentUserName,
            address: "Wagholi, Pune, MH",
            mob_number: "9518352333",
            storyData: [StoryData(image: AppImages.person, isView: false, name: "Your story")]
        )
        let profileNavigationController = UINavigationController(
            rootViewController: ProfileViewController(user: currentUser)
        )
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, profileNavigationController]
        return tabBarController
    }
}
