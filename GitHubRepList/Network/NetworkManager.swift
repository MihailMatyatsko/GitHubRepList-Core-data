//
//  NetworkManager.swift
//  GitHubRepList
//
//  Created by Mihael Matyatsko on 07.07.2021.
//

import Foundation
import CoreData

class NetworkManager {
    //MARK: - constants and variables
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    var url_resource:String = "https://api.github.com/search/repositories?q=stars%3A%3E0&sort=stars&order=desc&page="
    
    //MARK: - Methods for loading info from git API
    func getRepositories(completion: @escaping (LoadDataResult) -> () ){
        for pageNumber in 1..<5 {
            guard let url = URL(string: url_resource + pageNumber.description) else {
                return
            }
            session.dataTask(with: url) { [weak self] data, responce, error in
                var result: LoadDataResult
                defer {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                guard let strongSelf = self else {
                    result = .failure(error: error!)
                    return
                }
            if error == nil, let parseData = data {
                guard let repositories = try? strongSelf.decoder.decode(JSONFile.self, from: parseData) else {
                    result = .failure(error: error!)
                    return
                }
                result = .success(repositories: repositories)
            } else {
                result = .failure(error: error!)
            }

            }.resume()
        }
    }
}

    //MARK: - Parameterized enum
enum LoadDataResult {
    case success(repositories: JSONFile)
    case failure(error: Error)
}
