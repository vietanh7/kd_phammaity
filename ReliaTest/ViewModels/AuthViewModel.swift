//
//  AuthViewModel.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation
import Combine
import SwiftKeychainWrapper

protocol AuthDelegate: AnyObject {
    func requestSuccess()
    func requestError(error: String)
}

protocol AuthProtocol: AnyObject {
    func register(email: String, password: String)
    func login(email: String, password: String)
}

class AuthViewModel: AuthProtocol {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var serviceManager: NetworkServiceProtocol
    private weak var delegate: AuthDelegate?
    
    init(serviceManager: NetworkServiceProtocol = NetworkService.shared, delegate: AuthDelegate) {
        self.serviceManager = serviceManager
        self.delegate = delegate
    }
    
    func register(email: String, password: String) {
        self.serviceManager.register(email: email, password: password)
            .sink {[weak self] (response) in
            if let _ = response.error {
                self?.delegate?.requestError(error: "Register error")
            }else {
                self?.delegate?.requestSuccess()
            }
        }
        .store(in: &cancellableSet)
    }
    
    func login(email: String, password: String) {
        self.serviceManager.login(email: email, password: password)
            .sink {[weak self] (response) in
            if let _ = response.error {
                self?.delegate?.requestError(error: "Login error")
            }else {
                self?.saveToken(token: response.value?.token ?? "")
                self?.delegate?.requestSuccess()
            }
        }
        .store(in: &cancellableSet)
    }
    
    func saveToken(token: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: Constants.tokenKey)
        print("Save token success = \(saveSuccessful)")
    }
    
    
  
}
