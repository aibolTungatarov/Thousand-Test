//
//  MovieDetailVC.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = MovieDetailViewModel()
    private let reuseIdentifier1 = "cell"
    private let reuseIdentifier2 = "cell2"
    private let reuseIdentifier3 = "cell3"
    private let reuseIdentifier4 = "cell4"
    private var isRateSet = false
    var getFullImagePath: ((String)->(String))?
    var addToCoreData: ((MovieFav) -> Void)?
    let context = AppDelegate.viewContext
    
    var isFavourite: Bool = false {
        didSet {
            likedButton.isFavourite = isFavourite
        }
    }
    
    var movie: DetailedMovie? {
        didSet {
            guard let movie = movie else {return}
            if let getFullImagePath = getFullImagePath, let posterPath = movie.poster_path {
                imageString = getFullImagePath(posterPath)
            }
            if let movie_genres = movie.genres {
                setupGenreLabels(movie_genres)
            }
            titleStr = movie.original_title
            rate = movie.vote_average
            
            getComments(movieID: movie.id!)
        }
    }
    
    // MARK: - Views
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = UIFont.medium()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "liked"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = UIColor.buttonColor
        button.setTitle("Оценить фильм", for: .normal)
        button.titleLabel?.font = UIFont.medium(size: 17)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 40 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(changeFavourite), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.refreshControl = UIRefreshControl()
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: reuseIdentifier1)
        tableView.register(RateDetailCell.self, forCellReuseIdentifier: reuseIdentifier2)
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: reuseIdentifier3)
        tableView.register(CommentCell.self, forCellReuseIdentifier: reuseIdentifier4)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    fileprivate var likedButton: FavouriteButton = {
        let button = FavouriteButton()
        button.isFavourite = false
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(changeFavourite), for: .touchUpInside)
        return button
    }()
    
    fileprivate let bottomGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate let topGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate var containerForLabel: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    //Might be more than one
    fileprivate var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        return label
    }()
    
    fileprivate var rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate var titleStr: String? {
        didSet {
            titleLabel.text = titleStr
        }
    }
    
    fileprivate var rate: Double? {
        didSet {
            if let rate = rate {rateLabel.text = String(rate)}
        }
    }
    
    fileprivate var imageString: String? {
        didSet {
            if let imageString = imageString {imageView.loadImageFromUrl(urlString: imageString)}
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

//MAKR: - Actions
extension MovieDetailVC {
    @objc
    func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func changeFavourite() {
        isFavourite = !isFavourite
        likedButton.isFavourite = isFavourite
        changeCoreData(id: movie?.id ?? 0)
    }
}

//MARK: - Requests
extension MovieDetailVC {
    private func getComments(movieID: Int) {
        viewModel.getComment(movie_id: movieID, success: { [weak self] in
            guard let wSelf = self else { return }
            wSelf.tableView.reloadData()
        }) { (error) in
            
        }
    }
}

//MARK: - Methods
extension MovieDetailVC {
    // MARK: - Core Data

    func retriveFromCoreData(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieFav")
        fetchRequest.predicate = NSPredicate(format: "movieID = %d", id)

        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
            if results.count == 1 {
                let movieResult = (results[0] as! MovieFav)
                isFavourite = movieResult.isFav
                likedButton.isFavourite = isFavourite
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
    }

    func changeCoreData(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieFav")
        fetchRequest.predicate = NSPredicate(format: "movieID = %d", id)

        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
            if results.count == 1 {
                let movieResult = (results[0] as! MovieFav)
                movieResult.isFav = !movieResult.isFav
                saveContext()
            } else if results.count == 0 {
                if let movieFav: MovieFav = NSEntityDescription.insertNewObject(forEntityName: "MovieFav", into: self.context) as? MovieFav {
//                    addToCoreData(movieFav)
                    movieFav.isFav = isFavourite
                    movieFav.movieID = Int64(movie?.id ?? 0)
                    print(movieFav)
                }
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
    }


    func checkIfFavourite(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieFav")
        fetchRequest.predicate = NSPredicate(format: "movieID = %d", id)

        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
            if results.count == 1 {
                return (results[0] as! MovieFav).isFav
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return false
    }

    func removeFromCoreData(movieFav: MovieFav) {
        self.context.delete(movieFav)
        saveContext()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {

        }
    }
}

//MARK: - UITableView
extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 1 {
            return viewModel.commentsList.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier1, for: indexPath) as! ImageViewCell
                if let getFullImagePath = getFullImagePath, let poster_path =  movie?.poster_path {
                    cell.imageString = getFullImagePath(poster_path)
                }
                cell.genres = movie?.genres
                cell.isSet = isRateSet

                cell.titleStr = movie?.original_title
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! RateDetailCell
                cell.overview = movie?.overview
                cell.rateTMDB = movie?.vote_average
                cell.isSet = isRateSet

                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier3, for: indexPath)
                cell.addSubview(rateButton)
                cell.backgroundColor = .clear
                rateButton.snp.makeConstraints { (m) in
                    m.top.equalToSuperview().offset(10)
                    m.height.equalTo(40)
                    m.width.equalTo(200)
                    m.bottom.equalToSuperview().offset(-10).priority(.high)
                    m.centerX.centerY.equalToSuperview()
                }
                return cell
            }
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier4, for: indexPath) as! CommentCell
            cell.comment = viewModel.commentsList[indexPath.row]
            return cell
        }else {
            let cell = UITableViewCell()
//            addChild()
//            cell.addSubview()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.width * 1.3
            }else {
                return UITableView.automaticDimension
            }
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let headerView = HeaderView()
            headerView.label.text = section == 1 ? "Reviews" : "Recommendations"
            return headerView
        }
        return UIView()
    }
    
}

//MARK: - ConfigUI
extension MovieDetailVC {
    fileprivate func configUI() {
        view.backgroundColor = UIColor.backgroundColor
//        checkIfFavourite(id: (movie?.id!)!)
        retriveFromCoreData(id: (movie?.id ?? 0))
        [tableView, backButton, likedButton].forEach {
            view.addSubview($0)
        }
        isRateSet = true
        
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        tableView.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide)
            m.right.left.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            m.left.equalToSuperview().offset(10)
            m.height.width.equalTo(40)
        }
        
        likedButton.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-10)
            m.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            m.width.height.equalTo(40)
        }
    }
    
    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.backgroundColor.cgColor]
        gradientLayer.locations = [0.5, 1]
        bottomGradientContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = imageView.bounds
        gradientLayer.frame.origin.y -= imageView.bounds.height
        
        
    }
    
    func setupGenreLabels(_ genres: [Genre]) {
        
    }
}
