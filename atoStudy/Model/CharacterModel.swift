//
//  CharacterModel.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import Foundation

struct CharacterModel: Codable {
    let result: Bool?
    let message: String?
    let error: String?
    let data: [CharactersList]?
}

struct CharactersList: Codable {
    let characterSeq: Int?
    let engName: String?
    let korName: String?
    let filePath: String?
}
