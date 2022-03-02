//
//  RegisterRequest.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation

struct AuthRequest: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Codable {
    var token: String
}

struct RegisterResponse: Codable {
    var success: Bool
}

