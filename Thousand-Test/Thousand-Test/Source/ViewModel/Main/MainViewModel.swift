//
//  MainViewModel.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    let disposeBag = DisposeBag()
    var movie: Movies = Movies()
    var movieList: [Movie] = [Movie]()
    var searching: Bool = false
    var genresDict: [Int: String] = [Int: String]()
    var hasInternetConnection: Bool = true
    func getList(page: Int, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        getListApi(page: page)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movie in
                self.movie = movie
                if let movieList = movie.results {
                    if self.searching {
                        self.searching = false
                        self.movieList = movieList
                    }else{
                        self.movieList.append(contentsOf: movieList)
                    }
                }
                success()
            }, onError: { [unowned self] (error) in
                if let error = error as? ServiceError {
                    self.searching = false
                    failure(error)
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func getListApi(page: Int) -> Observable<Movies> {
        return ApiClient.shared.request(ApiRouter.getList(page: page))
    }
    
    func getMovieDetails(movie_id: Int, success: @escaping (DetailedMovie) -> Void, failure: @escaping (ServiceError) -> Void) {
        getMovieDetailsApi(movie_id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [unowned self] movie_details in
                    self.searching = false
                    success(movie_details)
                }, onError: { [unowned self] error in
                    self.searching = false
                    if let error = error as? ServiceError {
                        failure(error)
                    }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func getMovieDetailsApi(_ movie_id: Int) -> Observable<DetailedMovie> {
        return ApiClient.shared.request(ApiRouter.getMovieDetails(movie_id: movie_id))
    }
    
    
    func searchByText(_ text: String, page: Int, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        if !text.isEmpty {
            searchByTextApi(text, page: page)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] movie in
                    self.movie = movie
                    if let movieList = movie.results {
                        if self.searching == false {
                            self.movieList = movieList
                            self.searching = true
                        }else {
                            self.movieList.append(contentsOf: movieList)
                        }
                    }
                    print("Count is: ", self.movieList.count)
                    success()
                }, onError: { [unowned self] error in
                    self.searching = true
                    self.movie = Movies()
                    if let error = error as? ServiceError {
                        self.movieList = []
                        failure(error)
                    }
                    
                }).disposed(by: disposeBag)
        }
    }
    
    fileprivate func searchByTextApi(_ text: String, page: Int) -> Observable<Movies> {
        return ApiClient.shared.request(ApiRouter.searchByText(text: text, page: page))
    }
    
    
    func getGenres(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        getGenresApi()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] genres in
                guard let genres = genres.genres else {return}
                genres.forEach { (genre) in
                    self.genresDict[genre.id] = genre.name
                }
                    success()
                }, onError: { error in
                    failure(error)
                }).disposed(by: disposeBag)
    }
    
    fileprivate func getGenresApi() -> Observable<Genres> {
        return ApiClient.shared.request(ApiRouter.getGenres)
    }
}
