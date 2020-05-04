//
//  ViewController.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SVProgressHUD
import DZNEmptyDataSet

enum FilterType {
    case favourites, popular
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate let viewModel = MainViewModel()
    fileprivate let movieReusableCell = "movieReusableCell"
    fileprivate var filterType: FilterType = .popular
    fileprivate var movies = [MovieFav]()
    var itemSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.5)
    }
    
    // MARK: - Views
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a movie"
        searchController.searchBar.backgroundColor = UIColor.backgroundColor
        searchController.searchBar.barStyle = UIBarStyle.black
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Popular", "Search"]
        
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.itemSize.width - 30, height: self.itemSize.height)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: movieReusableCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.backgroundColor
//        collectionView.refreshControl = refreshControl
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        return collectionView
    }()
    
    private var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .white
        view.addTarget(self, action: #selector(updateList), for: .valueChanged)
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRequest()
        configUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
//MARK: - Requests
extension ViewController {
    fileprivate func makeRequest() {
        let dispatchGroup = DispatchGroup()
        getGenres(dg: dispatchGroup)
        dispatchGroup.notify(queue: .global(qos: .userInteractive)) { [unowned self] in
            self.getMovieList(page: 1)
        }
    }
    
    fileprivate func getMovieList(page: Int) {
        viewModel.getList(page: page, success: { [weak self] in
            guard let wSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                wSelf.collectionView.reloadData()
                wSelf.refreshControl.endRefreshing()
            }
        }) { [weak self] (error) in
            guard let wSelf = self else { return }
            wSelf.checkError(error: error)
            wSelf.refreshControl.endRefreshing()
        }
    }
    
    fileprivate func getFavourites() {
        
    }
    
    fileprivate func getMovieDetails(movie_id: Int) {
        viewModel.getMovieDetails(movie_id: movie_id, success: { [weak self] movie_details in
            guard let wSelf = self else { return }
            wSelf.goToMovieDetails(movie_details)
        }) { [weak self] (error) in
            guard let wSelf = self else { return }
            wSelf.checkError(error: error)
        }
    }
    
    fileprivate func getGenres(dg: DispatchGroup) {
        dg.enter()
        viewModel.getGenres(success: {
            dg.leave()
        }) { (error) in
            dg.leave()
        }
    }
    
    fileprivate func searchByText(text: String, page: Int) {
        viewModel.searchByText(text, page: page, success: { [weak self] in
            guard let wSelf = self else { return }
            wSelf.collectionView.reloadData()
        }) {[weak self] (error) in
            guard let wSelf = self else { return }
            wSelf.checkError(error: error)
        }
    }
}
//MARK: - Actions
extension ViewController {
    private func goToMovieDetails(_ movie_details: DetailedMovie) {
        let vc = MovieDetailVC()
        vc.movie = movie_details
        vc.getFullImagePath = { [unowned self] posterPath in
            return self.getFullImageString(imageString: posterPath)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func updateList() {
        getMovieList(page: 1)
    }
}
//MARK: - Methods
extension ViewController {
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func getFullImageString(imageString: String) -> String {
        return Constants.ProductionServer.imageURL + imageString
    }
    
    func getGenreByID(id: Int) -> String? {
        if viewModel.genresDict.keys.contains(id) {
            return viewModel.genresDict[id]!
        }
        return nil
    }
    
    func addToCoreData(movie: MovieFav) {
        self.movies.append(movie)
    }
}

//MARK: - UISearchDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: false, completion: nil)
        if let text = searchBar.text {
            viewModel.searching = false
            viewModel.movieList = [Movie]()
            viewModel.movie = Movies()
            searchByText(text: text, page: 1)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            searchController.dismiss(animated: false, completion: nil)
            getMovieList(page: 1)
        } else if selectedScope == 1 {
//            searchController.dismiss(animated: false, completion: nil)
//            getFavourites()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.selectedScopeButtonIndex = 1
    }
}


//MARK: - UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieReusableCell, for: indexPath) as! MovieViewCell
        cell.getFullImagePath = { [unowned self] posterPath in
            return self.getFullImageString(imageString: posterPath)
        }
        cell.movie = viewModel.movieList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: nil)
        }
        if let id = viewModel.movieList[indexPath.row].id {
            getMovieDetails(movie_id: id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Pagination
        guard let totalPages = viewModel.movie.total_pages, let current_page = viewModel.movie.page else { return }
        if indexPath.row == viewModel.movieList.count - 1 && viewModel.movieList.count > 0  && totalPages > current_page {
            let next_page = current_page + 1
            if viewModel.searching {
                if let text = searchController.searchBar.text {
                    searchByText(text: text, page: next_page)
                }
            }else if filterType == .popular {
                getMovieList(page: next_page)
            }
        }
    }
}

//MARK: - DZNEmptyDataSet
extension ViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if filterType == .popular && viewModel.searching && !viewModel.hasInternetConnection {
            let customView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height)))
            
            let button = UIButton()
            button.backgroundColor = .gray
            button.setTitle("Refresh", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.medium(size: 20)
            customView.addSubview(button)
            button.snp.makeConstraints { (m) in
                m.centerX.centerY.equalToSuperview()
                m.width.equalTo(90)
                m.height.equalTo(40)
            }
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.red.cgColor
            
            return customView
        }
        let customView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height)))
        let label = UILabel()
        label.textColor = .white
        label.contentMode = .center
        label.textAlignment = .center
        label.text = filterType == .popular ? "We couldn't find anything by query" :
            "Your favourites list is empty."
        label.numberOfLines = 0
        label.font = UIFont.medium()
        customView.addSubview(label)
        
        label.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.right.equalToSuperview().offset(-30)
            m.left.equalToSuperview().offset(30)
            m.centerX.equalToSuperview()
        }
        return customView
    }
}

//MARK: - ConfigUI
extension ViewController {
    fileprivate func configUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
//        searchController.searchBar.rx.text.asObservable()
//            .map { $0 ?? "" }
//            .bind(to: collectionView.)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        view.backgroundColor = UIColor.backgroundColor
        [collectionView].forEach {
            view.addSubview($0)
        }
        
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        collectionView.snp.makeConstraints { (m) in
            m.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func handleLogout() {
        UserDefaults.standard.removeObject(forKey: "SessionId")
        let mySceneDelegate = self.view.window?.windowScene?.delegate
        (mySceneDelegate as! SceneDelegate).confugureInitialViewController()
    }
}
