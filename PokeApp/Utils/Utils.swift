//
//  Utils.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation
import UIKit
import SwiftUI

extension UIFont {
    static func aronBlack(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Aron-Black", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

extension UIColor {
    static let customWhite = UIColor(hex: "#FFFFFF")
    static let customLightGray = UIColor(hex: "#F8F8F8")
    static let customGray1 = UIColor(hex: "#D9D9D6")
    static let customGray2 = UIColor(hex: "#AAAAAA")
    static let customGray3 = UIColor(hex: "#7C7C7C")
    static let customGray4 = UIColor(hex: "#404040")
    static let customBlack = UIColor(hex: "#141414")

    static let customBlueLight = UIColor(hex: "#9BB8D3")
    static let customBlue = UIColor(hex: "#2C85BC")
    static let customBlueBright = UIColor(hex: "#005FFF")
    static let customBlueDark = UIColor(hex: "#01426A") 
    static let customBlueDarker = UIColor(hex: "#01243A")

    static let customYellowLight = UIColor(hex: "#FFEFB7")
    static let customYellow = UIColor(hex: "#FFC600")
    static let customOrange = UIColor(hex: "#FFA800")

    static let customPeachLight = UIColor(hex: "#FFE4DD")
    static let customRedOrange = UIColor(hex: "#FF4210")

    static let customPurpleLight = UIColor(hex: "#E8D6FF")
    static let customPurple = UIColor(hex: "#760EFC")

    static let customGreenLight = UIColor(hex: "#65D498")
    static let customGreen = UIColor(hex: "#009444")
}
extension Color {
    static let customWhite = Color(UIColor.customWhite)
    static let customLightGray = Color(UIColor.customLightGray)
    static let customGray1 = Color(UIColor.customGray1)
    static let customGray2 = Color(UIColor.customGray2)
    static let customGray3 = Color(UIColor.customGray3)
    static let customGray4 = Color(UIColor.customGray4)
    static let customBlack = Color(UIColor.customBlack)

    static let customBlueLight = Color(UIColor.customBlueLight)
    static let customBlue = Color(UIColor.customBlue)
    static let customBlueBright = Color(UIColor.customBlueBright)
    static let customBlueDark = Color(UIColor.customBlueDark)
    static let customBlueDarker = Color(UIColor.customBlueDarker)

    static let customYellowLight = Color(UIColor.customYellowLight)
    static let customYellow = Color(UIColor.customYellow)
    static let customOrange = Color(UIColor.customOrange)

    static let customPeachLight = Color(UIColor.customPeachLight)
    static let customRedOrange = Color(UIColor.customRedOrange)

    static let customPurpleLight = Color(UIColor.customPurpleLight)
    static let customPurple = Color(UIColor.customPurple)

    static let customGreenLight = Color(UIColor.customGreenLight)
    static let customGreen = Color(UIColor.customGreen)
}
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
