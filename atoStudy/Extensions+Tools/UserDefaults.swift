//
//  UserDefaults.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/03.
//

import Foundation

func saveSnsType(_ snsType: String) {
    UserDefaults.standard.set(snsType, forKey: "snsType")
}

func getSnsType() -> String? {
    return UserDefaults.standard.string(forKey: "snsType")
}

func removeSnsType() {
    UserDefaults.standard.removeObject(forKey: "snsType")
}
