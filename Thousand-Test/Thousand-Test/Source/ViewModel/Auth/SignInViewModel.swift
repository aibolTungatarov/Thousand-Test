//
//  SignInViewModel.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class SignInViewModel {
    private let disposeBag = DisposeBag()
    var user: User!
    
}

// MARK: Methods
extension SignInViewModel {
    // #codeSmell
    func validateFields() {
        guard let username = user.username, !username.isEmpty else {
            SVProgressHUD.showError(withStatus: Constants.ERROR_EMPTY_USERNAME)
            return
        }
        
        guard let password = user.password, !password.isEmpty else {
            SVProgressHUD.showError(withStatus: Constants.ERROR_EMPTY_PASSWORD)
            return
        }
    }
    
    
    /// I don't like this part ///// #codeSmell
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        getRequestToken(success: {
            let username = self.user.username
            let password = self.user.password
            let requestToken = UserDefaults.standard.string(forKey: "RequestToken")
            self.getSessionWithLogin(username: username!, password: password!, requestToken: requestToken ?? "", success: {
                self.getSession(requestToken: requestToken!, success: {
                    let sessionId = UserDefaults.standard.string(forKey: "SessionId")
                    self.getAccount(sessionId: sessionId ?? "", success: {
                        onSuccess()
                    }, failure: { (_) in
                        // error
                    })
                }, failure: { (_) in
                    // error
                })
            }, failure: { (_) in
                // error
            })
        }) { (_) in
            // error
        }
    }
}


// MARK: Requests
extension SignInViewModel {
    func getRequestToken(success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        getRequsetTokenApi()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { token in
                UserDefaults.standard.set(token.request_token, forKey: "RequestToken")
                success()
            }, onError: { (error) in
                if let error = error as? ServiceError {
                    failure(error)
                }
            }).disposed(by: disposeBag)
    }
    
    func getRequsetTokenApi() -> Observable<RequestToken> {
        return ApiClient.shared.request(ApiRouter.requestToken)
    }
    
    func getSessionWithLogin(username: String, password: String, requestToken: String , success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        getSessionWithLoginApi(username: username, password: password, requestToken: requestToken)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { session in
                success()
            }, onError: { (error) in
                if let error = error as? ServiceError {
                    failure(error)
                }
            }).disposed(by: disposeBag)
    }
    
    func getSessionWithLoginApi(username: String, password: String, requestToken: String ) -> Observable<SessionWithLogin> {
        return ApiClient.shared.request(
            ApiRouter.createSessionWithLogin(username: username, password: password, requestToken: requestToken)
        )
    }
    
    func getSession(requestToken: String, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        getSessionApi(requestToken: requestToken)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { session in
                UserDefaults.standard.set(session.session_id, forKey: "SessionId")
                success()
            }, onError: { (error) in
                if let error = error as? ServiceError {
                    failure(error)
                }
            }).disposed(by: disposeBag)
    }
    
    func getSessionApi(requestToken: String) -> Observable<Session> {
        return ApiClient.shared.request(ApiRouter.createSession(requestToken: requestToken))
    }
    
    func getAccount(sessionId: String, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        getAccountApi(sessionId: sessionId)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { account in
                UserDefaults.standard.set(account.id, forKey: "AccountId")
                success()
            }, onError: { (error) in
                if let error = error as? ServiceError {
                    failure(error)
                }
            }).disposed(by: disposeBag)
    }
    
    func getAccountApi(sessionId: String) -> Observable<Account> {
        return ApiClient.shared.request(ApiRouter.getAccount(sessionId: sessionId))
    }
}
