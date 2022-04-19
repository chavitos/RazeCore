//
//  Networking.swift
//  RazeCore
//
//  Created by Tiago Chaves on 28/03/22.
//

import Foundation

protocol NetworkSession {
    func get(from url: URL, completion: @escaping ((Data?, Error?) -> Void))
    func post(with request: URLRequest, completion: @escaping ((Data?, Error?) -> Void))
}

extension URLSession: NetworkSession {
    func get(from url: URL, completion: @escaping ((Data?, Error?) -> Void)) {
        let task = dataTask(with: url) { data, _, error in
            completion(data, error)
        }
        task.resume()
    }
    
    func post(with request: URLRequest, completion: @escaping ((Data?, Error?) -> Void)) {
        let task = dataTask(with: request) { data, _, error in
            completion(data, error)
        }
        task.resume()
    }
}

extension RazeCore {
    public class Networking {
        
        /// Responsible for handling all networking calss
        /// - Warning: Must be create before using any public APIs
        public class Manager {
            public init() {}
            
            internal var session: NetworkSession = URLSession.shared
            
            /// Calls to the live internet to retrieve Data from a scpecific location
            /// - Parameters:
            ///   - url: The location you wish to fetch data from
            ///   - completionHandler: Returns a result object which signifies the status of the request
            public func loadData(from url: URL, completion: @escaping (NetworkResult<Data>) -> Void) {
                session.get(from: url) { data, error in
                    let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                    completion(result)
                }
            }
            
            
            /// Calls to the live internet to send data to a specific location
            /// - Warning: Make sure that the URL in question can accept a POST route
            /// - Parameters:
            ///   - body: The object you wish to send over the network
            ///   - url: The location you wish to send data to
            ///   - completion: Returns a result object which signifies the status of the request
            public func send<I: Codable>(_ body: I, to url: URL, completion: @escaping (NetworkResult<Data>) -> Void) {
                var request = URLRequest(url: url)
                do {
                    let body = try JSONEncoder().encode(body)
                    request.httpBody = body
                    request.httpMethod = "POST"
                    session.post(with: request) { data, error in
                        let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
                        completion(result)
                    }
                } catch let error {
                    return completion(.failure(error))
                }
            }
        }
        
        public enum NetworkResult<Value> {
            case success(Value)
            case failure(Error?)
        }
    }
}
