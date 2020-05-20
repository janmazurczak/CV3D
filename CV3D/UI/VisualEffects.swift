//
//  VisualEffects.swift
//  CV3D
//
//  Created by Jan Mazurczak on 19/05/2020.
//  Copyright © 2020 Jan Mazurczak. All rights reserved.
//

import CoreImage
import QuartzCore

public extension Array where Element == CIFilter {
    static func border() -> [CIFilter] {
        .box()
    }
    static func box() -> [CIFilter] {
        [
            CIFilter(name: "CILineOverlay", parameters: [:]),
            CIFilter(name: "CIBloom", parameters: [
                kCIInputRadiusKey : 6,
                kCIInputIntensityKey : 1
            ]),
            CIFilter(name: "CICrystallize", parameters: [
                kCIInputRadiusKey : 3
            ]),
            CIFilter(name: "CIFalseColor", parameters: [
                "inputColor0" : CIColor(color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
                "inputColor1" : CIColor(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            ])
        ].compactMap { $0 }
    }
    static func title() -> [CIFilter] {
        [
            CIFilter(name: "CIBloom", parameters: [
                kCIInputRadiusKey : 4,
                kCIInputIntensityKey : 0.3
            ]),
            CIFilter(name: "CICrystallize", parameters: [
                kCIInputRadiusKey : 2
            ]),
            CIFilter(name: "CIFalseColor", parameters: [
                "inputColor0" : CIColor(color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
                "inputColor1" : CIColor(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            ])
        ].compactMap { $0 }
    }
    static func text() -> [CIFilter] {
        [
            CIFilter(name: "CIBloom", parameters: [
                kCIInputRadiusKey : 1,
                kCIInputIntensityKey : 0.5
            ]),
            CIFilter(name: "CIFalseColor", parameters: [
                "inputColor0" : CIColor(color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
                "inputColor1" : CIColor(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            ])
        ].compactMap { $0 }
    }
    static func button() -> [CIFilter] {
        [
            CIFilter(name: "CIBloom", parameters: [
                kCIInputRadiusKey : 10,
                kCIInputIntensityKey : 1
            ]),
            CIFilter(name: "CICrystallize", parameters: [
                kCIInputRadiusKey : 2.5
                ])?.named("crystal"),
            CIFilter(name: "CIFalseColor", parameters: [
                "inputColor0" : CIColor(color: #colorLiteral(red: 0.23921568627450981, green: 0.6745098039215687, blue: 0.9686274509803922, alpha: 1.0)),
                "inputColor1" : CIColor(color: #colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))
            ])
        ].compactMap { $0 }
    }
}

extension CIFilter {
    func named(_ name: String) -> CIFilter {
        self.name = name
        return self
    }
}

public extension Array where Element == CIFilter {
    static func focusing() -> [CIFilter] {
        [
            CIFilter(name: "CIGaussianBlur", parameters: [
                kCIInputRadiusKey : 0
            ])?.named("blur")
        ].compactMap { $0 }
    }
}

extension CAAnimation {
    static func defocus(in duration: TimeInterval) -> CAAnimation {
        let blur = CABasicAnimation(keyPath: "filters.blur." + kCIInputRadiusKey)
        blur.fromValue = 0
        blur.toValue = 25
        let anim = CAAnimationGroup()
        anim.animations = [blur]
        anim.duration = duration
        anim.isRemovedOnCompletion = false
        anim.fillMode = .both
        return anim
    }
    static func focus(in duration: TimeInterval) -> CAAnimation {
        let blur = CABasicAnimation(keyPath: "filters.blur." + kCIInputRadiusKey)
        blur.fromValue = 25
        blur.toValue = 0
        let anim = CAAnimationGroup()
        anim.animations = [blur]
        anim.duration = duration
        anim.isRemovedOnCompletion = true
        anim.fillMode = .both
        return anim
    }
    static func spark() -> CAAnimation {
        let crystal = CAKeyframeAnimation(keyPath: "filters.crystal." + kCIInputRadiusKey)
        crystal.values = [1, 8, 1]
        let anim = CAAnimationGroup()
        anim.animations = [crystal]
        anim.duration = .random(in: 2.5...5)
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        anim.fillMode = .both
        return anim
    }
}
