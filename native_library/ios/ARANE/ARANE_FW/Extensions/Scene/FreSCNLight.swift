/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */

import Foundation
import ARKit

public extension SCNLight {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject, let type = String(rv["type"]) else { return nil }
        let fre = FreObjectSwift(rv)
        
        self.init()
        self.name = fre.name
        self.type = SCNLight.LightType(rawValue: type)
        self.intensity = fre.intensity
        
        guard fre.isDefault == false,
            let shadowMapSize = [Double](rv["shadowMapSize"]),
            shadowMapSize.count > 1 else { return } // don't go further if we are using default values
        
        if let clr: UIColor = fre.color {
            self.color = clr
        }
        self.temperature = fre.temperature
        self.castsShadow = fre.castsShadow
        if let shadowclr: UIColor = fre.shadowColor {
            self.shadowColor = shadowclr
        }
        self.shadowRadius = fre.shadowRadius
        self.shadowSampleCount = fre.shadowSampleCount
        self.shadowMode = SCNShadowMode(rawValue: fre.shadowMode) ?? .forward
        self.shadowBias = fre.shadowBias
        self.automaticallyAdjustsShadowProjection = fre.automaticallyAdjustsShadowProjection
        self.forcesBackFaceCasters = fre.forcesBackFaceCasters
        self.sampleDistributedShadowMaps = fre.sampleDistributedShadowMaps
        self.maximumShadowDistance = fre.maximumShadowDistance
        self.shadowCascadeCount = fre.shadowCascadeCount
        self.shadowCascadeSplittingFactor = fre.shadowCascadeSplittingFactor
        self.orthographicScale = fre.orthographicScale
        self.zNear = fre.zNear
        self.zFar = fre.zFar
        self.attenuationStartDistance = fre.attenuationStartDistance
        self.attenuationEndDistance = fre.attenuationEndDistance
        self.attenuationFalloffExponent = fre.attenuationFalloffExponent
        self.spotInnerAngle = fre.spotInnerAngle
        if let iesProfileURL: String = fre.iesProfileURL {
            self.iesProfileURL = URL(string: iesProfileURL)
        }
        self.shadowMapSize = CGSize(width: shadowMapSize[0], height: shadowMapSize[1])
        self.spotOuterAngle = fre.spotOuterAngle
        self.categoryBitMask = fre.categoryBitMask
//        if #available(iOS 13.0, *) {
////            fre.probeType = probeType.rawValue
////            fre.probeUpdateType = probeUpdateType.rawValue
//            // self.probeExtents = fre.probeExtents
//            fre.probeOffset = probeOffset
//            self.parallaxCorrectionEnabled = fre.parallaxCorrectionEnabled
//            //self.parallaxExtentsFactor = fre.parallaxExtentsFactor
//            //self.parallaxCenterOffset = fre.parallaxCenterOffset
//        }
        
    }
    
    func setProp(name: String, value: FREObject) {
        switch name {
        case "type":
            if let type = String(value) {
                self.type = SCNLight.LightType(rawValue: type)
            }
        case "color":
            if let clr = UIColor(value) {
                self.color = clr
            }
        case "temperature":
            self.temperature = CGFloat(value) ?? self.temperature
        case "intensity":
            self.intensity = CGFloat(value) ?? self.intensity
        case "castsShadow":
            self.castsShadow = Bool(value) ?? self.castsShadow
        case "shadowColor":
            if let shadowclr = UIColor(value) {
                self.shadowColor = shadowclr
            }
        case "shadowRadius":
            self.shadowRadius = CGFloat(value) ?? self.shadowRadius
        case "shadowSampleCount":
            self.shadowSampleCount = Int(value) ?? self.shadowSampleCount
        case "categoryBitMask":
            self.categoryBitMask = Int(value) ?? self.categoryBitMask
        case "shadowMode":
            if let shadowMode = Int(value) {
                self.shadowMode = SCNShadowMode(rawValue: shadowMode) ?? self.shadowMode
            }
        case "shadowBias":
            self.shadowBias = CGFloat(value) ?? self.shadowBias
        case "automaticallyAdjustsShadowProjection":
            self.automaticallyAdjustsShadowProjection = Bool(value) ?? self.automaticallyAdjustsShadowProjection
        case "forcesBackFaceCasters":
            self.forcesBackFaceCasters = Bool(value) ?? self.forcesBackFaceCasters
        case "sampleDistributedShadowMaps":
            self.sampleDistributedShadowMaps = Bool(value) ?? self.sampleDistributedShadowMaps
        case "maximumShadowDistance":
            self.maximumShadowDistance = CGFloat(value) ?? self.maximumShadowDistance
        case "shadowCascadeCount":
            self.shadowCascadeCount = Int(value) ?? self.shadowCascadeCount
        case "shadowCascadeSplittingFactor":
            self.shadowCascadeSplittingFactor = CGFloat(value) ?? self.shadowCascadeSplittingFactor
        case "orthographicScale":
            self.orthographicScale = CGFloat(value) ?? self.orthographicScale
        case "zNear":
            self.zNear = CGFloat(value) ?? self.zNear
        case "zFar":
            self.zFar = CGFloat(value) ?? self.zFar
        case "attenuationStartDistance":
            self.attenuationStartDistance = CGFloat(value) ?? self.attenuationStartDistance
        case "attenuationEndDistance":
            self.attenuationEndDistance = CGFloat(value) ?? self.attenuationEndDistance
        case "attenuationFalloffExponent":
            self.attenuationFalloffExponent = CGFloat(value) ?? self.attenuationFalloffExponent
        case "spotInnerAngle":
            self.spotInnerAngle = CGFloat(value) ?? self.spotInnerAngle
        case "spotOuterAngle":
            self.spotOuterAngle = CGFloat(value) ?? self.spotOuterAngle
        case "shadowMapSize":
            if let shadowMapSize = [Int](value) {
                if shadowMapSize.count > 1 {
                    self.shadowMapSize = CGSize(width: shadowMapSize[0], height: shadowMapSize[1])
                }
            }
        case "iesProfileURL":
            if let iesProfileURL = String(value) {
                self.iesProfileURL = URL(string: iesProfileURL)
            }
        default:
            break
        }
    }
    
    func toFREObject() -> FREObject? {
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.lights.Light", args: type.rawValue, name) else {
            return nil
        }
        fre.temperature = temperature
        fre.intensity = intensity
        fre.castsShadow = castsShadow
        fre.shadowRadius = shadowRadius
        fre.shadowSampleCount = shadowSampleCount
        fre.shadowMode = shadowMode.rawValue
        fre.shadowBias = shadowBias
        fre.automaticallyAdjustsShadowProjection = automaticallyAdjustsShadowProjection
        fre.forcesBackFaceCasters = forcesBackFaceCasters
        fre.sampleDistributedShadowMaps = sampleDistributedShadowMaps
        fre.maximumShadowDistance = maximumShadowDistance
        fre.shadowCascadeCount = shadowCascadeCount
        fre.shadowCascadeSplittingFactor = shadowCascadeSplittingFactor
        fre.orthographicScale = orthographicScale
        fre.zNear = zNear
        fre.zFar = zFar
        
        fre.attenuationStartDistance = attenuationStartDistance
        fre.attenuationEndDistance = attenuationEndDistance
        fre.attenuationFalloffExponent = attenuationFalloffExponent
        
        fre.spotInnerAngle = spotInnerAngle
        fre.spotOuterAngle = spotOuterAngle
        fre.categoryBitMask = categoryBitMask
        
        if let shadowColor = shadowColor as? UIColor {
            fre.shadowColor = shadowColor.toFREObject()
        }
        
        if let color = color as? UIColor {
            fre.color = color.toFREObject()
        }
        
        let arr: [Double] = [Double(self.shadowMapSize.width), Double(self.shadowMapSize.height)]
        fre.shadowMapSize = arr.toFREObject()
        
//        if #available(iOS 13.0, *) {
//            fre.probeType = probeType.rawValue
//            fre.probeUpdateType = probeUpdateType.rawValue
//            fre.probeExtents = probeExtents
//            fre.probeOffset = probeOffset
//            fre.parallaxCorrectionEnabled = parallaxCorrectionEnabled
//            fre.parallaxExtentsFactor = parallaxExtentsFactor
//            fre.parallaxCenterOffset = parallaxCenterOffset
//        }
        
        return fre.rawValue
    }
    
}
