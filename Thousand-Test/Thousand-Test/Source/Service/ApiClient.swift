//
//  ApiClient.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SVProgressHUD

class ApiClient {
    static let shared = ApiClient()
    func request<T: Codable>(_ apiRouter: ApiRouter) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRouter.asURLRequest()
            SVProgressHUD.show()
            Alamofire.request(request)
                .validate()
                .responseJSON { response in
                    SVProgressHUD.dismiss()
                    print(response.description)
                    if response.description.range(of: "-1009") != nil {
                        SVProgressHUD.dismiss()
                        print("No internet connection")
                        
                        observer.onError(ServiceError.noInternetConnection)
                        return
                    }
                    print("Request: ", request)
                    print("Request Type: ", apiRouter.method)
                    print("Status Code: ", response.response?.statusCode)
                    print("---------------------------")
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServiceError.notFound)
                            return
                        }
                        do {
                            let model: T = try JSONDecoder().decode(T.self, from: data)
    
                            observer.onNext(model)

                        } catch let error {

                            observer.onError(error)
                        }

                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            if let reason = ServiceError(rawValue: statusCode) {
                                observer.onError(reason)
                            }
                            observer.onError(error)
                        }else {
                        observer.onError(ServiceError.noInternetConnection)
                    }
                }
            }
            return Disposables.create()
        }
    }
}
