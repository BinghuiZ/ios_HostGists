//
//  MainViewModel.swift
//  HotGists
//
//  Created by Binghui Zhong on 27/2/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    public let gists: PublishSubject<[Gist]> = PublishSubject()
    public let detail: PublishSubject<Detail> = PublishSubject()
    
    public func requestData() {
        if let url = URL(string: "https://api.github.com/gists/public?since") {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    self.gists.onError(error)
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let values = try decoder.decode([Gist].self, from: data)
                        self.gists.onNext(values)
                        self.gists.onCompleted()
                    } catch {
                        print(error)
                        self.gists.onError(error)
                    }
                }
            }.resume()
        }
    }
    
    public func requestDetail(user: String) {
        if let url = URL(string: "https://api.github.com/users/\(user)/gists?since") {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    self.detail.onError(error)
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let values = try decoder.decode([Detail].self, from: data)
                        self.detail.onNext(values.first!)
                        self.detail.onCompleted()
                    } catch {
                        print(error)
                        self.detail.onError(error)
                    }
                }
            }.resume()
        }
    }
    
}
