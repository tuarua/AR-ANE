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
        guard
            let rv = freObject,
            let name = String(rv["name"]),
            let type = String(rv["type"]),
            let freColor = rv["color"],
            let temperature = CGFloat(rv["temperature"]),
            let intensity = CGFloat(rv["intensity"]),
            let castsShadow = Bool(rv["castsShadow"]),
            let freShadowColor = rv["shadowColor"],
            let shadowRadius = CGFloat(rv["shadowRadius"]),
            let shadowSampleCount = Int(rv["shadowSampleCount"]),
            let shadowMode = Int(rv["shadowMode"]),
            let shadowBias = CGFloat(rv["shadowBias"]),
            let automaticallyAdjustsShadowProjection = Bool(rv["automaticallyAdjustsShadowProjection"]),
            let forcesBackFaceCasters = Bool(rv["forcesBackFaceCasters"]),
            let sampleDistributedShadowMaps = Bool(rv["sampleDistributedShadowMaps"]),
            let maximumShadowDistance = CGFloat(rv["maximumShadowDistance"]),
            let shadowCascadeCount = Int(rv["shadowCascadeCount"]),
            let shadowCascadeSplittingFactor = CGFloat(rv["shadowCascadeSplittingFactor"]),
            let orthographicScale = CGFloat(rv["orthographicScale"]),
            let zNear = CGFloat(rv["zNear"]),
            let zFar = CGFloat(rv["zFar"]),
            let attenuationStartDistance = CGFloat(rv["attenuationStartDistance"]),
            let attenuationEndDistance = CGFloat(rv["attenuationEndDistance"]),
            let attenuationFalloffExponent = CGFloat(rv["attenuationFalloffExponent"]),
            let spotInnerAngle = CGFloat(rv["spotInnerAngle"]),
            let spotOuterAngle = CGFloat(rv["spotOuterAngle"]),
            let shadowMapSize = Array<Double>(rv["shadowMapSize"]),
            let categoryBitMask = Int(rv["categoryBitMask"]),
            shadowMapSize.count > 1
            else { return nil }
        self.init()

        self.name = name
        self.type = SCNLight.LightType.init(rawValue: type)
        if let clr = UIColor.init(freObjectARGB: freColor) {
            self.color = clr
        }
        self.temperature = temperature
        self.intensity = intensity
        self.castsShadow = castsShadow
        if let shadowclr = UIColor.init(freObjectARGB: freShadowColor) {
            self.shadowColor = shadowclr
        }
        self.shadowRadius = shadowRadius
        self.shadowSampleCount = shadowSampleCount
        self.shadowMode = SCNShadowMode.init(rawValue: shadowMode) ?? .forward
        self.shadowBias = shadowBias
        self.automaticallyAdjustsShadowProjection = automaticallyAdjustsShadowProjection
        self.forcesBackFaceCasters = forcesBackFaceCasters
        self.sampleDistributedShadowMaps = sampleDistributedShadowMaps
        self.maximumShadowDistance = maximumShadowDistance
        self.shadowCascadeCount = shadowCascadeCount
        self.shadowCascadeSplittingFactor = shadowCascadeSplittingFactor
        self.orthographicScale = orthographicScale
        self.zNear = zNear
        self.zFar = zFar
        self.attenuationStartDistance = attenuationStartDistance
        self.attenuationEndDistance = attenuationEndDistance
        self.attenuationFalloffExponent = attenuationFalloffExponent
        self.spotInnerAngle = spotInnerAngle
        if let iesProfileURL = String(rv["iesProfileURL"]) {
            self.iesProfileURL = URL.init(string: iesProfileURL)
        }
        self.shadowMapSize = CGSize.init(width: shadowMapSize[0], height: shadowMapSize[1])
        self.spotOuterAngle = spotOuterAngle
        self.categoryBitMask = categoryBitMask
        // self.gobo // TODO
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "type":
            if let type = String(value) {
                self.type = SCNLight.LightType.init(rawValue: type)
            }
            break
        case "color":
            if let clr = UIColor.init(freObjectARGB: value) {
                self.color = clr
            }
            break
        case "temperature":
            self.temperature = CGFloat(value) ?? self.temperature
            break
        case "intensity":
            self.intensity = CGFloat(value) ?? self.intensity
            break
        case "castsShadow":
            self.castsShadow = Bool(value) ?? self.castsShadow
            break
        case "shadowColor":
            if let shadowclr = UIColor.init(freObjectARGB: value) {
                self.shadowColor = shadowclr
            }
            break
        case "shadowRadius":
            self.shadowRadius = CGFloat(value) ?? self.shadowRadius
            break
        case "shadowSampleCount":
            self.shadowSampleCount = Int(value) ?? self.shadowSampleCount
            break
        case "categoryBitMask":
            self.categoryBitMask = Int(value) ?? self.categoryBitMask
            break
        case "shadowMode":
            if let shadowMode = Int(value) {
                self.shadowMode = SCNShadowMode.init(rawValue: shadowMode) ?? self.shadowMode
            }
            break
        case "shadowBias":
            self.shadowBias = CGFloat(value) ?? self.shadowBias
            break
        case "automaticallyAdjustsShadowProjection":
            self.automaticallyAdjustsShadowProjection = Bool(value) ?? self.automaticallyAdjustsShadowProjection
            break
        case "forcesBackFaceCasters":
            self.forcesBackFaceCasters = Bool(value) ?? self.forcesBackFaceCasters
            break
        case "sampleDistributedShadowMaps":
            self.sampleDistributedShadowMaps = Bool(value) ?? self.sampleDistributedShadowMaps
            break
        case "maximumShadowDistance":
            self.maximumShadowDistance = CGFloat(value) ?? self.maximumShadowDistance
            break
        case "shadowCascadeCount":
            self.shadowCascadeCount = Int(value) ?? self.shadowCascadeCount
            break
        case "shadowCascadeSplittingFactor":
            self.shadowCascadeSplittingFactor = CGFloat(value) ?? self.shadowCascadeSplittingFactor
            break
        case "orthographicScale":
            self.orthographicScale = CGFloat(value) ?? self.orthographicScale
            break
        case "zNear":
            self.zNear = CGFloat(value) ?? self.zNear
            break
        case "zFar":
            self.zFar = CGFloat(value) ?? self.zFar
            break
        case "attenuationStartDistance":
            self.attenuationStartDistance = CGFloat(value) ?? self.attenuationStartDistance
            break
        case "attenuationEndDistance":
            self.attenuationEndDistance = CGFloat(value) ?? self.attenuationEndDistance
            break
        case "attenuationFalloffExponent":
            self.attenuationFalloffExponent = CGFloat(value) ?? self.attenuationFalloffExponent
            break
        case "spotInnerAngle":
            self.spotInnerAngle = CGFloat(value) ?? self.spotInnerAngle
            break
        case "spotOuterAngle":
            self.spotOuterAngle = CGFloat(value) ?? self.spotOuterAngle
            break
        case "shadowMapSize":
            if let shadowMapSize = Array<Int>(value) {
                if shadowMapSize.count > 1 {
                    self.shadowMapSize = CGSize.init(width: shadowMapSize[0], height: shadowMapSize[1])
                }
            }
            break
        case "iesProfileURL":
            if let iesProfileURL = String(value) {
                self.iesProfileURL = URL.init(string: iesProfileURL)
            }
            break
        default:
            break
        }
    }
    
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.Light")
            try ret?.setProp(name: "name", value: self.name?.toFREObject())
            try ret?.setProp(name: "type", value: self.type.rawValue.toFREObject())
            try ret?.setProp(name: "temperature", value: self.temperature.toFREObject())
            try ret?.setProp(name: "intensity", value: self.intensity.toFREObject())
            try ret?.setProp(name: "castsShadow", value: self.castsShadow.toFREObject())
            try ret?.setProp(name: "shadowRadius", value: self.shadowRadius.toFREObject())
            try ret?.setProp(name: "shadowSampleCount", value: self.shadowSampleCount.toFREObject())
            try ret?.setProp(name: "shadowMode", value: self.shadowMode.rawValue.toFREObject())
            try ret?.setProp(name: "shadowBias", value: self.shadowBias.toFREObject())
            try ret?.setProp(name: "automaticallyAdjustsShadowProjection", value: self.automaticallyAdjustsShadowProjection.toFREObject())
            try ret?.setProp(name: "forcesBackFaceCasters", value: self.forcesBackFaceCasters.toFREObject())
            try ret?.setProp(name: "sampleDistributedShadowMaps", value: self.sampleDistributedShadowMaps.toFREObject())
            try ret?.setProp(name: "maximumShadowDistance", value: self.maximumShadowDistance.toFREObject())
            try ret?.setProp(name: "shadowCascadeCount", value: self.shadowCascadeCount.toFREObject())
            try ret?.setProp(name: "shadowCascadeSplittingFactor", value: self.shadowCascadeSplittingFactor.toFREObject())
            try ret?.setProp(name: "orthographicScale", value: self.orthographicScale.toFREObject())
            try ret?.setProp(name: "zNear", value: self.zNear.toFREObject())
            try ret?.setProp(name: "zFar", value: self.zFar.toFREObject())
            
            try ret?.setProp(name: "attenuationStartDistance", value: self.attenuationStartDistance.toFREObject())
            try ret?.setProp(name: "attenuationEndDistance", value: self.attenuationEndDistance.toFREObject())
            try ret?.setProp(name: "attenuationFalloffExponent", value: self.attenuationFalloffExponent.toFREObject())
            
            try ret?.setProp(name: "spotInnerAngle", value: self.spotInnerAngle.toFREObject())
            try ret?.setProp(name: "spotOuterAngle", value: self.spotOuterAngle.toFREObject())
            try ret?.setProp(name: "categoryBitMask", value: self.categoryBitMask.toFREObject())
            if let shadowColor = self.shadowColor as? UIColor {
                try ret?.setProp(name: "shadowColor", value: shadowColor.toFREObjectARGB())
            }
            if let color = self.color as? UIColor {
                try ret?.setProp(name: "color", value: color.toFREObjectARGB())
            }

            let arr:Array<Double> = [Double(self.shadowMapSize.width), Double(self.shadowMapSize.height)]
            try ret?.setProp(name: "shadowMapSize", value: arr.toFREObject()) //TODO confirm this works
            
            return ret
        } catch {
        }
        return nil
    }
    
}
