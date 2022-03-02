//
//  NetworkService.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation
import Combine
import Alamofire
import SwiftKeychainWrapper

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

protocol NetworkServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<DataResponse<LoginResponse, NetworkError>, Never>
    func register(email: String, password: String) -> AnyPublisher<DataResponse<RegisterResponse, NetworkError>, Never>
    func addProduct(_ product: Product) -> AnyPublisher<DataResponse<Product, NetworkError>, Never>
    func updateProduct(_ product: Product) -> AnyPublisher<DataResponse<Product, NetworkError>, Never>
    func deleteProduct(sku: String) -> AnyPublisher<DataResponse<Product, NetworkError>, Never>
    func fetchProuducts() -> AnyPublisher<DataResponse<[Product], NetworkError>, Never>
    func searchProduct(sku: String) -> AnyPublisher<DataResponse<Product, NetworkError>, Never>
}

class NetworkService: NetworkServiceProtocol {
    
    enum ApiResquest: String {
        case register = "register"
        case login = "auth/login"
        case search = "item/search"
        case getAll = "items"
        case addProduct = "item/add"
        case updateProduct = "item/update"
        case deleteProduct = "item/delete"
    }
    
    static let shared: NetworkServiceProtocol = NetworkService()
    private let baseUrlString = "https://hoodwink.medkomtek.net/api/"
    private init() { }
    
    func login(email: String, password: String) -> AnyPublisher<DataResponse<LoginResponse, NetworkError>, Never> {
        let body = AuthRequest(email: email, password: password)
        let jsonData = body.dictionary
       
        let urlString = baseUrlString + ApiResquest.login.rawValue
        let url = URL(string: urlString)!
        let requestData = AF.request(url,method: .post, parameters: jsonData, encoding: URLEncoding.httpBody)
        
        return makeRequest(request: requestData)
    }
    
    func register(email: String, password: String) -> AnyPublisher<DataResponse<RegisterResponse, NetworkError>, Never> {
        let body = AuthRequest(email: email, password: password)
        let jsonData = body.dictionary
       
        let urlString = baseUrlString + ApiResquest.register.rawValue
        let url = URL(string: urlString)!
        let requestData = AF.request(url,method: .post, parameters: jsonData, encoding: URLEncoding.httpBody)
        
        return makeRequest(request: requestData)
    }
    
    func addProduct(_ product: Product) -> AnyPublisher<DataResponse<Product, NetworkError>, Never> {
        let urlString = baseUrlString + ApiResquest.addProduct.rawValue
        let url = URL(string: urlString)!
        
        let jsonData = product.dictionary
        let headers = self.getHeaders()
        
        let requestData = AF.request(url, method: .post, parameters: jsonData, encoding: URLEncoding.httpBody, headers: headers)
        
        return makeRequest(request: requestData)
    }
    
    func updateProduct(_ product: Product) -> AnyPublisher<DataResponse<Product, NetworkError>, Never> {
        let jsonData = product.dictionary
       
        let urlString = baseUrlString + ApiResquest.addProduct.rawValue
        let url = URL(string: urlString)!
        let headers = self.getHeaders()
        
        let requestData = AF.request(url, method: .post, parameters: jsonData, encoding: URLEncoding.httpBody, headers: headers)
        
        return makeRequest(request: requestData)
    }
    
    func deleteProduct(sku: String) -> AnyPublisher<DataResponse<Product, NetworkError>, Never> {
        let jsonData = ["sku": sku]
       
        let urlString = baseUrlString + ApiResquest.deleteProduct.rawValue
        let url = URL(string: urlString)!
        let headers = self.getHeaders()
        
        let requestData = AF.request(url, method: .post, parameters: jsonData, encoding: URLEncoding.httpBody, headers: headers)
        
        return makeRequest(request: requestData)
    }
    
    func fetchProuducts() -> AnyPublisher<DataResponse<[Product], NetworkError>, Never> {
        let urlString = baseUrlString + ApiResquest.getAll.rawValue
        let url = URL(string: urlString)!
        
        let requestData = AF.request(url, method: .get)
        
        return makeRequest(request: requestData)
    }
    
    func searchProduct(sku: String) -> AnyPublisher<DataResponse<Product, NetworkError>, Never> {
        let jsonData = ["sku": sku]
       
        let urlString = baseUrlString + ApiResquest.search.rawValue
        let url = URL(string: urlString)!
        let headers = self.getHeaders()
        
        let requestData = AF.request(url, method: .post, parameters: jsonData, encoding: URLEncoding.httpBody, headers: headers)
        
        return makeRequest(request: requestData)
    }
    
    func getHeaders() -> HTTPHeaders? {
        guard let token = KeychainWrapper.standard.string(forKey: Constants.tokenKey) else {
            return nil
        }
        
        return [.authorization(bearerToken: token)]
    }
    
    func makeRequest<T: Decodable>(request: DataRequest) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        return request
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let systemError = response.data.flatMap {
                        try? JSONDecoder().decode(SystemError.self, from: $0)
                    }
                    return NetworkError(error: error, systemError: systemError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
