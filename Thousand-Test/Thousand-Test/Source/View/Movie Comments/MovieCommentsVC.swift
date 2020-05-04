//
//  MovieCommentsVC.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

class MovieCommentsVC: UIViewController {
    
    let movieID: Int!
    private let viewModel = MovieCommentsViewModel()
    private let reuseIdentifier = "reuseIdentifier"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getComments()
    }
    
    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Requests
extension MovieCommentsVC {
    private func getComments() {
        viewModel.getComment(movie_id: movieID, success: { [weak self] in
            guard let wSelf = self else { return }
            wSelf.tableView.reloadData()
        }) { (error) in
            
        }
    }
}

//MARK: - Methods
extension MovieCommentsVC {
    
}

//MARK: - Actions
extension MovieCommentsVC {
    
}

//MARK: - UITableViewDelegate
extension MovieCommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.comment = viewModel.commentsList[indexPath.row]
        return cell
    }
}

//MARK: - ConfigUI
extension MovieCommentsVC {
    private func configUI() {
        makeConstraints()
    }
    
    private func makeConstraints() {
        
    }
}
