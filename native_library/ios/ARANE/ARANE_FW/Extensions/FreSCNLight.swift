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
            let id = String(rv["id"]),
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
            let shadowMapSize = Array<Int>(rv["shadowMapSize"]),
            shadowMapSize.count > 1
            else { return nil }
        self.init()

        self.name = id
        self.type = SCNLight.LightType.init(rawValue: type)
        self.color = UIColor.init(freObject: freColor)
        self.temperature = temperature
        self.intensity = intensity
        self.castsShadow = castsShadow
        self.shadowColor = UIColor.init(freObjectARGB: freShadowColor)
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
        //self.categoryBitMask int // TODO
        // self.gobo // TODO
    }
}

/*
 private var _gobo:MaterialProperty;
 */
