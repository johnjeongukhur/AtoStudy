//
//  SpoqaFonts.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import Foundation
import UIKit

enum AtoStudyFont {
    case Bold // 700
    case Regular // 500
    case Medium // 400
    
    var font: String {
        switch self {
        case .Bold: return "SpoqaHanSansNeo-Bold"
        case .Regular: return "SpoqaHanSansNeo-Medium"
        case .Medium: return "SpoqaHanSansNeo-Regular"
        }
    }
}

enum AtoStudyColor {
    case Primary900
    case Black900
    case Black800
    case Black500
    case Black400

    var color: UIColor {
        switch self {
        case .Primary900: return UIColor(hex: "6428D4")
        case .Black900: return UIColor(hex: "333333")
        case .Black800: return UIColor(hex: "666666")
        case .Black500: return UIColor(hex: "E6E6E6")
        case .Black400: return UIColor(hex: "F2F2F2")
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
