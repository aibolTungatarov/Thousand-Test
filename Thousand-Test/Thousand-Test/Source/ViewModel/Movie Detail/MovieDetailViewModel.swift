//
//  MovieDetailViewModel.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
import RxSwift
class MovieDetailViewModel {
    let disposeBag = DisposeBag()
    var comments: Comments = Comments()
    var commentsList: [Comment] = [Comment]()
    func getComment(movie_id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        getCommentApi(movie_id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] comments in
                guard let wSelf = self else { return }
                wSelf.comments = comments
                if let results = comments.results {
                    wSelf.commentsList = results
                }
                success()
                }, onError: { error in
                    failure(error)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func getCommentApi(_ movie_id: Int, page: Int = 1) -> Observable<Comments> {
        return ApiClient.shared.request(ApiRouter.getComment(movie_id: movie_id, page: page))
    }
}


// MARK: Requests
extension MovieDetailViewModel {
    func markFavorite(movie_id: Int, fav: Bool) {
        markFavorite(movie_id: movie_id, fav: fav, success: {
            
        }) { (_) in
            
        }
    }
    
    func markFavorite(movie_id: Int, fav: Bool, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        markFavoriteApi(movie_id: movie_id, fav: fav)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { status in
                success()
            }, onError: { (error) in
                if let error = error as? ServiceError {
                    failure(error)
                }
            }).disposed(by: disposeBag)
    }
    
    func markFavoriteApi(movie_id: Int, fav: Bool) -> Observable<Status> {
        let media_type = "movie"
        let sessionId = UserDefaults.standard.string(forKey: "SessionId") ?? ""
        let account_id = UserDefaults.standard.string(forKey: "AccountId") ?? ""
        return ApiClient.shared.request(
            ApiRouter.markFavourite(
                account_id: Int(account_id) ?? 0 ,
                sessionId: sessionId,
                media_id: movie_id,
                fav: fav,
                media_type: media_type
        ))
    }
}


// MARK: Methods
extension MovieDetailViewModel {
//    func makeFavorite() {
//        self.isFavourite = !self.isFavourite;
//        markFavorite(movie_id: detailedMovie.id ?? 0, fav: self.isFavourite)
//    }
//
//    func getImageForFav() -> String {
//        var imageString: String = ""
//        if isFavourite {
//            imageString = "star_filled"
//        } else {
//            imageString = "star"
//        }
//        return imageString
//    }
}
