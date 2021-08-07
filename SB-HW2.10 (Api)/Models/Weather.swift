//
//  Weather.swift
//  SB-HW2.10 (Api)
//
//  Created by Vladislav Kulak on 06.08.2021.
//

import Foundation

struct Weather: Decodable {
    let now: Int?
    let now_dt: String?
    let info: Info?
    let fact: Fact?
    
}

struct Info:Decodable {
    let lat: Double?
    let lon: Double?
    let url: String?
}

struct Fact: Decodable {
    let temp: Int?
    let feels_like: Int?
    let icon: String?
    let wind_speed: Double?
    let pressure_mm: Int?
}
