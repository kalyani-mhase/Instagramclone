//
//  HomeViewController.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var topBar: TopNavigationBar!
    private let viewModel = HomeViewmodel()
    private let refreshControl = UIRefreshControl()
    private var appliedInitialTopInset = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        self.tblView.register(UINib(nibName: "UserPostCell", bundle: nil), forCellReuseIdentifier: "UserPostCell")
        removeCustomBottomBar()
        topBar.topHeader.text = "Instagram"
        topBar.onMessageTap = { [weak self] in
            self?.showMessages()
        }
        configureScrollingHeader()
        tblView.contentInset = .zero
        tblView.verticalScrollIndicatorInsets = .zero
        tblView.horizontalScrollIndicatorInsets = .zero
        tblView.contentInsetAdjustmentBehavior = .automatic
        tblView.sectionHeaderTopPadding = 0
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        tblView.refreshControl = refreshControl
       
        
    }
    
    private func configureScrollingHeader() {
        guard let header = topBar else { return }

        let headerConstraints = view.constraints.filter { constraint in
            (constraint.firstItem as? UIView) === header ||
            (constraint.secondItem as? UIView) === header
        }
        NSLayoutConstraint.deactivate(headerConstraints)
        header.removeFromSuperview()
        header.translatesAutoresizingMaskIntoConstraints = true
        header.frame = CGRect(x: 0, y: 0, width: tblView.bounds.width, height: 44)
        tblView.tableHeaderView = header
    }

    private func removeCustomBottomBar() {
        guard let bottomBar = view.subviews.first(where: {
            $0 !== tblView && $0 !== topBar && $0.frame.minY > view.bounds.midY
        }) else { return }

        let bottomBarConstraints = view.constraints.filter {
            ($0.firstItem as? UIView) === bottomBar || ($0.secondItem as? UIView) === bottomBar
        }
        NSLayoutConstraint.deactivate(bottomBarConstraints)
        bottomBar.removeFromSuperview()
        tblView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !appliedInitialTopInset {
            let topInset = view.safeAreaInsets.top
            tblView.contentInset.top = topInset
            tblView.verticalScrollIndicatorInsets.top = topInset
            tblView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: false)
            appliedInitialTopInset = true
        }

        guard let header = tblView.tableHeaderView else { return }
        var headerFrame = header.frame
        if headerFrame.width != tblView.bounds.width {
            headerFrame.size.width = tblView.bounds.width
            header.frame = headerFrame
            tblView.tableHeaderView = header
        }
    }

    @objc private func refreshFeed() {
        // The feed currently uses local sample data, so refreshing reloads the visible posts.
        tblView.reloadData()
        refreshControl.endRefreshing()
    }

    private func showMessages() {
        let messagesController = MessagesViewController(
            viewModel: MessagingFeatureFactory.makeMessagesViewModel(),
            makeConversationViewModel: MessagingFeatureFactory.makeConversationViewModel(for:)
        )
        let navigationController = UINavigationController(rootViewController: messagesController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    private func showPostOptions(at postIndex: Int) {
        guard DataSource.users.indices.contains(postIndex) else { return }

        let post = DataSource.users[postIndex]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if DataSource.isCurrentUser(post.user_name) {
            alert.addAction(UIAlertAction(title: "Delete post", style: .destructive) { [weak self] _ in
                self?.deletePost(at: postIndex)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = alert.popoverPresentationController,
           let cell = tblView.cellForRow(at: IndexPath(row: postIndex, section: 1)) as? UserPostCell {
            popover.sourceView = cell
            popover.sourceRect = cell.contentView.bounds
        }
        present(alert, animated: true)
    }

    private func deletePost(at postIndex: Int) {
        guard DataSource.users.indices.contains(postIndex),
              DataSource.isCurrentUser(DataSource.users[postIndex].user_name) else {
            return
        }

        DataSource.users.remove(at: postIndex)
        tblView.deleteRows(at: [IndexPath(row: postIndex, section: 1)], with: .automatic)
    }

    private func showComments(for post: PostData, at postIndex: Int) {
        let commentsViewController = CommentsViewController(comments: post.comments)
        commentsViewController.onCommentsChanged = { comments in
            guard DataSource.users.indices.contains(postIndex) else { return }
            DataSource.users[postIndex].comments = comments
        }
        commentsViewController.modalPresentationStyle = .pageSheet

        if #available(iOS 15.0, *), let sheet = commentsViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }

        present(commentsViewController, animated: true)
    }

    @IBAction func homePressed(_ sender: Any) {
    }
    
    @IBAction func seeProfile(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func wathcReels(_ sender: Any) {
    }
    
    @IBAction func searchPressed(_ sender: Any) {
    }
    
    @IBAction func addContained(_ sender: Any) {
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return DataSource.users.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tblView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as?  UserCell {
                cell.stodyData = viewModel.storyData
                cell.collectionView.reloadData()
                cell.cellOnTap = { [weak self] imageName  in
                    self?.preView(img: imageName)
                }
                
                return cell
            }
        } else{
            if let cell = tblView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as?  UserPostCell {
                cell.post = DataSource.users[indexPath.row]
                cell.onFavoriteAction = {
                    DataSource.users[indexPath.row].isLike = !(DataSource.users[indexPath.row].isLike)
                    self.reloadRow(indexPath: [indexPath])
                }
                cell.onCommentAction = { [weak self] in
                    self?.showComments(for: DataSource.users[indexPath.row], at: indexPath.row)
                }
                cell.onBookMarkAction = {
                    DataSource.users[indexPath.row].isBookMark = !(DataSource.users[indexPath.row].isBookMark)
                    self.reloadRow(indexPath: [indexPath])
                }
                cell.onMoreAction = { [weak self] in
                    self?.showPostOptions(at: indexPath.row)
                }

                cell.setupUI()
                return cell
            }
        }
        return UITableViewCell()
    }
    func reloadRow(indexPath: [IndexPath]) {
        self.tblView.reloadRows(at: indexPath, with: .none)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func preView(img: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

       if let popupVC = storyboard.instantiateViewController(
            withIdentifier: "PreviewViewController"
       ) as? PreviewViewController {
           
           popupVC.str = "person"
           
           popupVC.modalPresentationStyle = .overFullScreen
           popupVC.modalTransitionStyle = .crossDissolve
        
           
           
           present(popupVC, animated: true)
           //        let vc = PreviewViewController()
           //        vc.str = img
           //        self.present(vc, animated: true)
       }
    }
}
