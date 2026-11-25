import UIKit

class UserPostCell: UITableViewCell {
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var favoriteOutlet: UIButton!
    @IBOutlet weak var commentOutlet: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var bookMarkOutlet: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!

    var onFavoriteAction: (() -> Void)?
    var onCommentAction: (() -> Void)?
    var onBookMarkAction: (() -> Void)?
    var onMoreAction: (() -> Void)?
    var post: PostData?
    private var previousCollectionSize: CGSize = .zero

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(
            UINib(nibName: "PostCell", bundle: nil),
            forCellWithReuseIdentifier: "PostCell"
        )

        if let layout = postCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        postCollectionView.isPagingEnabled = true
        postCollectionView.showsHorizontalScrollIndicator = false
    }

    func setupUI() {
        usernameLabel.text = post?.user_name
        usernameLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        favoriteOutlet.setImage(
            UIImage(named: post?.isLike == true ? AppImages.heart : AppImages.favourite),
            for: .normal
        )
        bookMarkOutlet.setImage(
            UIImage(named: post?.isBookMark == true ? AppImages.bookmark_fill : AppImages.bookMark),
            for: .normal
        )
        shareOutlet.setImage(UIImage(named: AppImages.send), for: .normal)

        postCollectionView.reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard postCollectionView.bounds.size != previousCollectionSize else { return }
        previousCollectionSize = postCollectionView.bounds.size
        postCollectionView.collectionViewLayout.invalidateLayout()
    }

    @IBAction func moreAction(_ sender: Any) {
        onMoreAction?()
    }

    @IBAction func favoriteAction(_ sender: Any) {
        onFavoriteAction?()
    }

    @IBAction func postComments(_ sender: Any) {
        onCommentAction?()
    }

    @IBAction func sharePost(_ sender: Any) {}

    @IBAction func bookMarkPost(_ sender: Any) {
        onBookMarkAction?()
    }
}

extension UserPostCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        post?.posts.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PostCell",
                for: indexPath
            ) as? PostCell,
            let post,
            post.posts.indices.contains(indexPath.item)
        else {
            return UICollectionViewCell()
        }

        cell.postImg.image = UIImage(named: post.posts[indexPath.item])
        cell.postImg.contentMode = .scaleAspectFill
        cell.postImg.clipsToBounds = true
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
