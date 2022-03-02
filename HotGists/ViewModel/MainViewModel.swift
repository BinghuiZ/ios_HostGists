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
    
    let USER_DEFAULT_FAVOURITE_ITEMS_KEY = "FAVOURITE_ITEMS"
    
    public let gists: PublishSubject<[GistUIModel]> = PublishSubject()
    public let detail: PublishSubject<DetailUIModel> = PublishSubject()
    
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
                        let mappedValues = values.map { gist in
                            return GistUIModel(gist: gist, isFavouriteItem: self.getFavourite(id: gist.id))
                        }
                        self.gists.onNext(mappedValues)
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
                        let uiModel = DetailUIModel(detail: values.first!, isFavouriteItem: self.getFavourite(id: values.first!.id))
                        self.detail.onNext(uiModel)
                        self.detail.onCompleted()
                    } catch {
                        print(error)
                        self.detail.onError(error)
                    }
                }
            }.resume()
        }
    }
    
    func updateFavourite(id: String) {
        let defaults = UserDefaults.standard
        let optionalIds = defaults.object(forKey: USER_DEFAULT_FAVOURITE_ITEMS_KEY) as? [String:Bool]
        var map = optionalIds ?? [String:Bool]()
        if let liked = map[id] {
            map[id] = !liked
        } else {
            map[id] = true
        }
        defaults.set(map, forKey: USER_DEFAULT_FAVOURITE_ITEMS_KEY)
    }
    
    func getFavourite(id: String) -> Bool {
         if let ids = UserDefaults.standard.object(forKey: USER_DEFAULT_FAVOURITE_ITEMS_KEY) as? [String:Bool],
            let liked = ids[id] {
             return liked
         }
        return false
    }
    
}
