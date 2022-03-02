//
//  Gist.swift
//  HotGists
//
//  Created by Binghui Zhong on 26/2/2022.
//

import Foundation

struct Gist: Decodable {
    let id, url: String
    let files: DecodedFileArray
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case files = "files"
        case owner = "owner"
    }
    
    struct DecodedFileArray: Decodable {
        var array: [File]
        
        // Define DynamicCodingKeys type needed for creating
        // decoding container from JSONDecoder
        private struct DynamicCodingKeys: CodingKey {
            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            // Use for integer-keyed dictionary
            var intValue: Int?
            init?(intValue: Int) {
                // We are not using this, thus just return nil
                return nil
            }
        }
        
        init(from decoder: Decoder) throws {
            
            // 1
            // Create a decoding container using DynamicCodingKeys
            // The container will contain all the JSON first level key
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
            
            var tempArray = [File]()
            
            // 2
            // Loop through each key (student ID) in container
            for key in container.allKeys {
                
                // Decode Student using key & keep decoded Student object in tempArray
                let decodedObject = try container.decode(File.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                tempArray.append(decodedObject)
            }
            
            // 3
            // Finish decoding all Student objects. Thus assign tempArray to array.
            array = tempArray
        }
    }
    
    struct File: Decodable {
        let filename: String
        
        enum CodingKeys: String, CodingKey {
            case filename
        }
    }
    
    struct Owner: Decodable {
        let login: String
        
        enum CodingKeys: String, CodingKey {
            case login
        }
    }

}

struct GistUIModel {
    let gist: Gist
    var isFavouriteItem: Bool = false
}
