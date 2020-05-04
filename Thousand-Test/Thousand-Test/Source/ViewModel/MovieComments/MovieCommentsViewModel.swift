//
//  MovieCommentsViewModel.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
import RxSwift
class MovieCommentsViewModel {
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
