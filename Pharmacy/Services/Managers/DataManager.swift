//
//  DataManager.swift
//  Pharmacy
//
//  Created by Mikhail Timoscenko on 16.06.2020.
//  Copyright © 2020 pharmacy. All rights reserved.
//

import Foundation
import Moya

struct Responce<U: Decodable>: Decodable {
    let message: String
    let status: String
    let data: U
}

protocol ParseKeyPath {
    static var parseKeyPathExtension: String { get }
}

class DataManager<T, U> where T: TargetType, U: Decodable {

    public let provider = MoyaProvider<T>(plugins: DataManager.plugins)
    public internal(set) var  data: U?
    public var completion: ((Result<U, MoyaError>) -> Void)?
    public var deleteCompletion: ((Result<Bool, MoyaError>) -> Void)?
    public var updateCompletion: ((Result<Bool, MoyaError>) -> Void)?
    public var createCompletion: ((Result<Bool, MoyaError>) -> Void)?

    public internal(set) var isLoading: Bool = false

    // MARK: - Class vars
    class var plugins: [Moya.PluginType] {
        var result = [PluginType]()

        let accessPlugin = AccessTokenPlugin { _ in
            return KeychainManager.shared.getToken() ?? ""
        }
        result.append(accessPlugin)

        return result
    }

    // MARK: - Data Load
    public func load(target: T, completion: @escaping (_ result: Result<U, MoyaError>) -> Void) {
        
        isLoading = true
        self.completion = completion
        provider.request(target, completion: requestCompletion)
    }

    public func requestCompletion(with result: Swift.Result<Moya.Response, Moya.MoyaError>) {
        switch result {
        case let .success(response):
            do {
                let successResponse = try response.filterSuccessfulStatusCodes()
                let jsonDecoder = JSONDecoder()
                let keyPath: String

                if let parse = U.self as? ParseKeyPath.Type {
                    keyPath = parse.parseKeyPathExtension
                } else {
                    keyPath = String()
                }

                let responceData = try successResponse.map(Responce<U>.self,
                                                           atKeyPath: keyPath,
                                                           using: jsonDecoder,
                                                           failsOnEmptyData: false)
               
                self.data = responceData.data
                isLoading = false
                self.completion?(.success(responceData.data))
            } catch let error as MoyaError {
                isLoading = false
                self.completion?(.failure(error))
            } catch {
                isLoading = false
                self.completion?(.failure(MoyaError.underlying(error, nil)))
            }
        case let .failure(error):
            isLoading = false
            self.completion?(.failure(error))
        }
    }
    // MARK: - delete request
    public func delete(target: T, completion: @escaping (_ result: Result<Bool, MoyaError>) -> Void) {
        isLoading = true
        self.deleteCompletion = completion
        provider.request(target, completion: deleteCompletion)
    }
    public func deleteCompletion(with result: Swift.Result<Moya.Response, MoyaError>) {
        switch result {
        case let .success(response):
            do {
                let successResponse = try response.filterSuccessfulStatusCodes()

                isLoading = false
                self.deleteCompletion?(.success(successResponse.statusCode == 200))
            } catch let error as MoyaError {
                isLoading = false
                self.deleteCompletion?(.failure(error))
            } catch {
                isLoading = false
                self.deleteCompletion?(.failure(MoyaError.underlying(error, nil)))
            }
        case let .failure(error):
            isLoading = false
            self.deleteCompletion?(.failure(error))
        }
    }
    // MARK: - update request
    public func update(target: T, completion: @escaping (_ result: Result<Bool, MoyaError>) -> Void) {
        isLoading = true
        self.updateCompletion = completion
        provider.request(target, completion: updateCompletion)
    }

    public func updateCompletion(with result: Swift.Result<Moya.Response, MoyaError>) {
        switch result {
        case let .success(response):
            do {
                let successResponse = try response.filterSuccessfulStatusCodes()

                isLoading = false
                self.updateCompletion?(.success(successResponse.statusCode == 200))
            } catch let error as MoyaError {
                isLoading = false
                self.updateCompletion?(.failure(error))
            } catch {
                isLoading = false
                self.updateCompletion?(.failure(MoyaError.underlying(error, nil)))
            }
        case let .failure(error):
            isLoading = false
            self.updateCompletion?(.failure(error))
        }
    }

    public func create(target: T, completion: @escaping (_ result: Result<Bool, MoyaError>) -> Void) {
        isLoading = true
        self.createCompletion = completion
        provider.request(target, completion: createCompletion)
    }
    
    public func createCompletion(with result: Swift.Result<Moya.Response, MoyaError>) {
        switch result {
        case let .success(response):
            do {
                let successResponse = try response.filterSuccessfulStatusCodes()

                isLoading = false
                self.createCompletion?(.success(successResponse.statusCode == 200))
            } catch let error as MoyaError {
                isLoading = false
                self.createCompletion?(.failure(error))
            } catch {
                isLoading = false
                self.createCompletion?(.failure(MoyaError.underlying(error, nil)))
            }
        case let .failure(error):
            isLoading = false
            self.createCompletion?(.failure(error))
        }
    }
}
