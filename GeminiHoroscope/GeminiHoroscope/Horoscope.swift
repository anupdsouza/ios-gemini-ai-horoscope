//
//  Horoscope.swift
//  GeminiHoroscope
//
//  Created by Anup D'Souza on 19/01/24.
//

import Foundation

struct Horoscope: Codable {
    let date: String
    let horoscope_data: String
}

struct HoroscopeResponse: Decodable {
    let data: Horoscope
    let status: Int
    let success: Bool
}
