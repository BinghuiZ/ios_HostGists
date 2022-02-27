//
//  MainViewModel.swift
//  HotGists
//
//  Created by Binghui Zhong on 27/2/2022.
//

import Foundation

class MainViewModel {
    
    public func requestData() {
        if let url = URL(string: "https://api.github.com/gists/public?since") {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let values = try decoder.decode([Gist].self, from: data)
                        print(values)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
}