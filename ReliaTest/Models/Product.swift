//
//  Product.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation

struct Product: Codable {
    var sku: String = ""
    var productName: String = ""
    var quantity: Int = 0
    var price: Double = 0
    var unit: String = ""
    var status: Int = 1
    var createdAt: Date?
    var updatedAt: Date?
    

    enum CodingKeys: String, CodingKey {
        case sku
        case productName = "product_name"
        case quantity = "qty"
        case price
        case unit
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(sku: String, name: String, price: Double, unit: String, quantity: Int){
        self.sku = sku
        self.productName = name
        self.price = price
        self.unit = unit
        self.quantity = quantity
        self.status = 1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            sku = try container.decode(String.self, forKey: .sku)
            productName = try container.decode(String.self, forKey: .productName)
            quantity = try container.decode(Int.self, forKey: .quantity)
            price = try container.decode(Double.self, forKey: .price)
            
            status = try container.decode(Int.self, forKey: .status)
            unit = try container.decode(String.self, forKey: .unit)
        } catch {
            
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
