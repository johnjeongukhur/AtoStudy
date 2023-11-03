//
//  ResgistModel.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import Foundation

struct RegistModel: Codable {
    let result: Bool?
    let message: String?
    let error: ErrorResponse?
    //TODO: 추후 데이터 타입 확인하기
    let data: RegistData?
//    let data: String?
}

struct RegistErrorModel: Codable {
    let result: Bool?
    let message: String?
    let error: ErrorResponse?
//    let data: RegistData?
    let data: String?
}


struct RegistData: Codable {
    let snsType: String?
    let nickname: String?
    let character: Int?
    let characterName: String?
}

struct ErrorResponse: Codable {
    let code: String?
    let viewType: String?
    let message: String?
}
