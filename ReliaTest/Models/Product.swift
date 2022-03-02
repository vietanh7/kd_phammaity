//
//  Product.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation

struct Product: Codable {
    var id: Int
    var sku: String
    var productName: String
    var quantity: Int
    var price: Double
    var unit: String
    var image: String?
    var status: Int
    var createdAt: Date?
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case productName = "product_name"
        case quantity = "qty"
        case price
        case unit
        case image
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        sku = try container.decode(String.self, forKey: .sku)
        productName = try container.decode(String.self, forKey: .productName)
        quantity = try container.decode(Int.self, forKey: .quantity)
        price = try container.decode(Double.self, forKey: .price)
        
        status = try container.decode(Int.self, forKey: .status)
        unit = try container.decode(String.self, forKey: .unit)
        
        do {
            image = try container.decode(String.self, forKey: .image)
        } catch {
            image = nil
        }
        
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let createdDateString = try container.decode(String.self, forKey: .createdAt)
        if let date = iso8601DateFormatter.date(from: createdDateString) {
            createdAt = date
        }
        
        let updatedDateString = try container.decode(String.self, forKey: .updatedAt)
        if let date = iso8601DateFormatter.date(from: updatedDateString) {
            updatedAt = date
        }
    }
}
