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

public extension SCNMaterial {
    func applyMaterial(_ propName:String, _ material:SCNMaterialProperty) {
        var mat:SCNMaterialProperty?
        
        switch propName {
        case "diffuse":
            mat = self.diffuse
            break
        case "ambient":
            mat = self.ambient
            break
        case "specular":
            mat = self.specular
            break
        case "emission":
            mat = self.emission
            break
        case "transparent":
            mat = self.transparent
            break
        case "reflective":
            mat = self.reflective
            break
        case "multiply":
            mat = self.multiply
            break
        case "normal":
            mat = self.normal
            break
        case "displacement":
            mat = self.displacement
            break
        case "ambientOcclusion":
            mat = self.ambientOcclusion
            break
        case "selfIllumination":
            mat = self.selfIllumination
            break
        case "metalness":
            mat = self.metalness
            break
        case "roughness":
            mat = self.roughness
            break
        default:
            break
        }
        
        mat?.contents = material.contents
        mat?.intensity = material.intensity
        mat?.magnificationFilter = material.magnificationFilter
        mat?.minificationFilter = material.minificationFilter
        mat?.mipFilter = material.mipFilter
        mat?.wrapS = material.wrapS
        mat?.wrapT = material.wrapT
        mat?.mappingChannel = material.mappingChannel
        mat?.maxAnisotropy = material.maxAnisotropy
        
    }
    
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let freId:FREObject = rv["id"],
            let freShininess:FREObject = rv["shininess"],
            let freTransparency:FREObject = rv["transparency"],
            let freLightingModel:FREObject = rv["lightingModel"],
            let freIsLitPerPixel:FREObject =  rv["isLitPerPixel"],
            let freIsDoubleSided:FREObject =  rv["isDoubleSided"],
            let freFillMode:FREObject = rv["fillMode"],
            let freCullMode:FREObject = rv["cullMode"],
            let freTransparencyMode:FREObject = rv["transparencyMode"],
            let freLocksAmbientWithDiffuse:FREObject = rv["locksAmbientWithDiffuse"],
            let freWritesToDepthBuffer:FREObject =  rv["writesToDepthBuffer"],
            let freColorBufferWriteMask:FREObject = rv["colorBufferWriteMask"],
            let freReadsFromDepthBuffer:FREObject =  rv["readsFromDepthBuffer"],
            let freFresnelExponent:FREObject = rv["fresnelExponent"],
            let freBlendMode:FREObject = rv["blendMode"]
            else {
                return nil
        }
    
        guard
            let id = String(freId),
            let shininess = CGFloat(freShininess),
            let transparency = CGFloat(freTransparency),
            let lightingModel = String(freLightingModel),
            let isLitPerPixel = Bool(freIsLitPerPixel),
            let isDoubleSided = Bool(freIsDoubleSided),
            let fillMode = UInt(freFillMode),
            let cullMode = Int(freCullMode),
            let transparencyMode = Int(freTransparencyMode),
            let locksAmbientWithDiffuse = Bool(freLocksAmbientWithDiffuse),
            let writesToDepthBuffer = Bool(freWritesToDepthBuffer),
            let colorBufferWriteMask = Int(freColorBufferWriteMask),
            let readsFromDepthBuffer = Bool(freReadsFromDepthBuffer),
            let fresnelExponent = CGFloat(freFresnelExponent),
            let blendMode = Int(freBlendMode)
            else {
                return nil
        }
    
        self.init()
        
        self.name = id
        if let freDiffuse:FREObject = rv["diffuse"],
            let diffuse = SCNMaterialProperty.init(freDiffuse) {
            self.applyMaterial("diffuse", diffuse)
        }
        if let freAmbient:FREObject = rv["ambient"],
            let ambient = SCNMaterialProperty.init(freAmbient) {
            self.applyMaterial("ambient", ambient)
        }
        if let freSpecular:FREObject = rv["specular"],
            let specular = SCNMaterialProperty.init(freSpecular) {
            self.applyMaterial("specular", specular)
        }
        if let freEmission:FREObject = rv["emission"],
            let emission = SCNMaterialProperty.init(freEmission) {
            self.applyMaterial("emission", emission)
        }
        if let freTransparent:FREObject = rv["transparent"],
            let transparent = SCNMaterialProperty.init(freTransparent) {
            self.applyMaterial("diffuse", transparent)
        }
        if let freReflective:FREObject = rv["reflective"],
            let reflective = SCNMaterialProperty.init(freReflective) {
            self.applyMaterial("reflective", reflective)
        }
        if let freMultiply:FREObject = rv["multiply"],
            let multiply = SCNMaterialProperty.init(freMultiply) {
            self.applyMaterial("multiply", multiply)
        }
        if let freNormal:FREObject = rv["normal"],
            let normal = SCNMaterialProperty.init(freNormal) {
            self.applyMaterial("normal", normal)
        }
        if let freDisplacement:FREObject = rv["displacement"],
            let displacement = SCNMaterialProperty.init(freDisplacement) {
            self.applyMaterial("displacement", displacement)
        }
        if let freAmbientOcclusion:FREObject = rv["ambientOcclusion"],
            let ambientOcclusion = SCNMaterialProperty.init(freAmbientOcclusion) {
            self.applyMaterial("ambientOcclusion", ambientOcclusion)
        }
        if let freSelfIllumination:FREObject = rv["selfIllumination"],
            let selfIllumination = SCNMaterialProperty.init(freSelfIllumination) {
            self.applyMaterial("selfIllumination", selfIllumination)
        }
        if let freMetalness:FREObject = rv["metalness"],
            let metalness = SCNMaterialProperty.init(freMetalness) {
            self.applyMaterial("metalness", metalness)
        }
        if let freRoughness:FREObject = rv["roughness"],
            let roughness = SCNMaterialProperty.init(freRoughness) {
            self.applyMaterial("roughness", roughness)
        }

        self.shininess = shininess
        self.transparency = transparency
        self.lightingModel = LightingModel.init(rawValue: lightingModel)
        self.isLitPerPixel = isLitPerPixel
        self.isDoubleSided = isDoubleSided
        self.fillMode = SCNFillMode.init(rawValue: fillMode) ?? .fill
        self.cullMode = SCNCullMode.init(rawValue: cullMode) ?? .back
        self.transparencyMode = SCNTransparencyMode.init(rawValue: transparencyMode) ?? .default
        self.locksAmbientWithDiffuse = locksAmbientWithDiffuse
        self.writesToDepthBuffer = writesToDepthBuffer
        self.colorBufferWriteMask = SCNColorMask.init(rawValue: colorBufferWriteMask)
        self.readsFromDepthBuffer = readsFromDepthBuffer
        self.fresnelExponent = fresnelExponent
        self.blendMode = SCNBlendMode.init(rawValue: blendMode) ?? .alpha
        
    }
    
    func setMaterialPropertyProp(type:String, name:String, value:FREObject) {
        switch type {
        case "diffuse":
            self.diffuse.setProp(name: name, value: value)
            break
        default:
            break
        }
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "shininess":
            self.shininess = CGFloat(value) ?? self.shininess
            break
        case "transparency":
            self.transparency = CGFloat(value) ?? self.transparency
            break
        case "lightingModel":
            if let lightingModel = String(value) {
                self.lightingModel = LightingModel.init(rawValue: lightingModel)
            }
            break
        case "isLitPerPixel":
            self.isLitPerPixel = Bool(value) ?? self.isLitPerPixel
            break
        case "isDoubleSided":
            self.isDoubleSided = Bool(value) ?? self.isDoubleSided
            break
        case "fillMode":
            if let fillMode = UInt(value) {
                self.fillMode = SCNFillMode.init(rawValue: fillMode) ?? self.fillMode
            }
            break
        case "cullMode":
            if let cullMode = Int(value) {
                self.cullMode = SCNCullMode.init(rawValue: cullMode) ?? self.cullMode
            }
            break
        case "transparencyMode":
            if let transparencyMode = Int(value) {
                self.transparencyMode = SCNTransparencyMode.init(rawValue: transparencyMode) ?? self.transparencyMode
            }
            break
        case "isDoubleSided":
            self.isDoubleSided = Bool(value) ?? self.isDoubleSided
            break
        case "locksAmbientWithDiffuse":
            self.locksAmbientWithDiffuse = Bool(value) ?? self.locksAmbientWithDiffuse
            break
        case "writesToDepthBuffer":
            self.writesToDepthBuffer = Bool(value) ?? self.writesToDepthBuffer
            break
        case "colorBufferWriteMask":
            if let colorBufferWriteMask = Int(value) {
                self.colorBufferWriteMask = SCNColorMask.init(rawValue: colorBufferWriteMask)
            }
            break
        case "readsFromDepthBuffer":
            self.readsFromDepthBuffer = Bool(value) ?? self.readsFromDepthBuffer
            break
        case "fresnelExponent":
            self.fresnelExponent = CGFloat(value) ?? self.fresnelExponent
            break
        case "blendMode":
            if let blendMode = Int(value) {
                 self.blendMode = SCNBlendMode.init(rawValue: blendMode) ?? .alpha
            }
            break
        default:
            break
        }
        
    }
    
}
