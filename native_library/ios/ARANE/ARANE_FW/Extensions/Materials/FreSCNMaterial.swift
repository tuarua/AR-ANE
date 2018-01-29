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
    func applyMaterial(_ propName: String, _ material: SCNMaterialProperty) {
        var mat: SCNMaterialProperty?
        switch propName {
        case "diffuse":
            mat = self.diffuse
        case "ambient":
            mat = self.ambient
        case "specular":
            mat = self.specular
        case "emission":
            mat = self.emission
        case "transparent":
            mat = self.transparent
        case "reflective":
            mat = self.reflective
        case "multiply":
            mat = self.multiply
        case "normal":
            mat = self.normal
        case "displacement":
            mat = self.displacement
        case "ambientOcclusion":
            mat = self.ambientOcclusion
        case "selfIllumination":
            mat = self.selfIllumination
        case "metalness":
            mat = self.metalness
        case "roughness":
            mat = self.roughness
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
        guard
            let rv = freObject,
            let name = String(rv["name"]),
            let shininess = CGFloat(rv["shininess"]),
            let transparency = CGFloat(rv["transparency"]),
            let lightingModel = String(rv["lightingModel"]),
            let isLitPerPixel = Bool(rv["isLitPerPixel"]),
            let isDoubleSided = Bool(rv["isDoubleSided"]),
            let fillMode = UInt(rv["fillMode"]),
            let cullMode = Int(rv["cullMode"]),
            let transparencyMode = Int(rv["transparencyMode"]),
            let locksAmbientWithDiffuse = Bool(rv["locksAmbientWithDiffuse"]),
            let writesToDepthBuffer = Bool(rv["writesToDepthBuffer"]),
            let colorBufferWriteMask = Int(rv["colorBufferWriteMask"]),
            let readsFromDepthBuffer = Bool(rv["readsFromDepthBuffer"]),
            let fresnelExponent = CGFloat(rv["fresnelExponent"]),
            let blendMode = Int(rv["blendMode"])
            else {
                return nil
        }
    
        self.init()
        
        self.name = name
        
        if let freDiffuse: FREObject = rv["diffuse"],
            Bool(freDiffuse["isDefault"]) == false,
            let diffuse = SCNMaterialProperty(freDiffuse) {
            self.applyMaterial("diffuse", diffuse)
        }
        if let freAmbient: FREObject = rv["ambient"],
            Bool(freAmbient["isDefault"]) == false,
            let ambient = SCNMaterialProperty(freAmbient) {
            self.applyMaterial("ambient", ambient)
        }
        if let freSpecular: FREObject = rv["specular"],
            Bool(freSpecular["isDefault"]) == false,
            let specular = SCNMaterialProperty(freSpecular) {
            self.applyMaterial("specular", specular)
        }
        if let freEmission: FREObject = rv["emission"],
            Bool(freEmission["isDefault"]) == false,
            let emission = SCNMaterialProperty(freEmission) {
            self.applyMaterial("emission", emission)
        }
        if let freTransparent: FREObject = rv["transparent"],
            Bool(freTransparent["isDefault"]) == false,
            let transparent = SCNMaterialProperty(freTransparent) {
            self.applyMaterial("transparent", transparent)
        }
        if let freReflective: FREObject = rv["reflective"],
            Bool(freReflective["isDefault"]) == false,
            let reflective = SCNMaterialProperty(freReflective) {
            self.applyMaterial("reflective", reflective)
        }
        if let freMultiply: FREObject = rv["multiply"],
            Bool(freMultiply["isDefault"]) == false,
            let multiply = SCNMaterialProperty(freMultiply) {
            self.applyMaterial("multiply", multiply)
        }
        if let freNormal: FREObject = rv["normal"],
            Bool(freNormal["isDefault"]) == false,
            let normal = SCNMaterialProperty(freNormal) {
            self.applyMaterial("normal", normal)
        }
        if let freDisplacement: FREObject = rv["displacement"],
            Bool(freDisplacement["isDefault"]) == false,
            let displacement = SCNMaterialProperty(freDisplacement) {
            self.applyMaterial("displacement", displacement)
        }
        if let freAmbientOcclusion: FREObject = rv["ambientOcclusion"],
            Bool(freAmbientOcclusion["isDefault"]) == false,
            let ambientOcclusion = SCNMaterialProperty(freAmbientOcclusion) {
            self.applyMaterial("ambientOcclusion", ambientOcclusion)
        }
        if let freSelfIllumination: FREObject = rv["selfIllumination"],
            Bool(freSelfIllumination["isDefault"]) == false,
            let selfIllumination = SCNMaterialProperty(freSelfIllumination) {
            self.applyMaterial("selfIllumination", selfIllumination)
        }
        if let freMetalness: FREObject = rv["metalness"],
            Bool(freMetalness["isDefault"]) == false,
            let metalness = SCNMaterialProperty(freMetalness) {
            self.applyMaterial("metalness", metalness)
        }
        if let freRoughness: FREObject = rv["roughness"],
            Bool(freRoughness["isDefault"]) == false,
            let roughness = SCNMaterialProperty(freRoughness) {
            self.applyMaterial("roughness", roughness)
        }

        self.shininess = shininess
        self.transparency = transparency
        self.lightingModel = LightingModel(rawValue: lightingModel)
        self.isLitPerPixel = isLitPerPixel
        self.isDoubleSided = isDoubleSided
        self.fillMode = SCNFillMode(rawValue: fillMode) ?? .fill
        self.cullMode = SCNCullMode(rawValue: cullMode) ?? .back
        self.transparencyMode = SCNTransparencyMode(rawValue: transparencyMode) ?? .default
        self.locksAmbientWithDiffuse = locksAmbientWithDiffuse
        self.writesToDepthBuffer = writesToDepthBuffer
        self.colorBufferWriteMask = SCNColorMask(rawValue: colorBufferWriteMask)
        self.readsFromDepthBuffer = readsFromDepthBuffer
        self.fresnelExponent = fresnelExponent
        self.blendMode = SCNBlendMode(rawValue: blendMode) ?? .alpha
        
    }
    
    func setMaterialPropertyProp(type: String, name: String, value: FREObject) {
        switch type {
        case "diffuse":
            self.diffuse.setProp(name: name, value: value)
        case "ambient":
            self.ambient.setProp(name: name, value: value)
        case "specular":
            self.specular.setProp(name: name, value: value)
        case "emission":
            self.emission.setProp(name: name, value: value)
        case "transparent":
            self.transparent.setProp(name: name, value: value)
        case "reflective":
            self.reflective.setProp(name: name, value: value)
        case "multiply":
            self.multiply.setProp(name: name, value: value)
        case "normal":
            self.normal.setProp(name: name, value: value)
        case "displacement":
            self.displacement.setProp(name: name, value: value)
        case "ambientOcclusion":
            self.ambientOcclusion.setProp(name: name, value: value)
        case "selfIllumination":
            self.selfIllumination.setProp(name: name, value: value)
        case "metalness":
            self.metalness.setProp(name: name, value: value)
        case "roughness":
            self.roughness.setProp(name: name, value: value)
        default:
            break
        }
    }
    
    func setProp(name: String, value: FREObject) {
        switch name {
        case "shininess":
            self.shininess = CGFloat(value) ?? self.shininess
        case "transparency":
            self.transparency = CGFloat(value) ?? self.transparency
        case "lightingModel":
            if let lightingModel = String(value) {
                self.lightingModel = LightingModel.init(rawValue: lightingModel)
            }
        case "isLitPerPixel":
            self.isLitPerPixel = Bool(value) ?? self.isLitPerPixel
        case "isDoubleSided":
            self.isDoubleSided = Bool(value) ?? self.isDoubleSided
        case "fillMode":
            if let fillMode = UInt(value) {
                self.fillMode = SCNFillMode(rawValue: fillMode) ?? self.fillMode
            }
        case "cullMode":
            if let cullMode = Int(value) {
                self.cullMode = SCNCullMode(rawValue: cullMode) ?? self.cullMode
            }
        case "transparencyMode":
            if let transparencyMode = Int(value) {
                self.transparencyMode = SCNTransparencyMode(rawValue: transparencyMode) ?? self.transparencyMode
            }
        case "isDoubleSided":
            self.isDoubleSided = Bool(value) ?? self.isDoubleSided
        case "locksAmbientWithDiffuse":
            self.locksAmbientWithDiffuse = Bool(value) ?? self.locksAmbientWithDiffuse
        case "writesToDepthBuffer":
            self.writesToDepthBuffer = Bool(value) ?? self.writesToDepthBuffer
        case "colorBufferWriteMask":
            if let colorBufferWriteMask = Int(value) {
                self.colorBufferWriteMask = SCNColorMask(rawValue: colorBufferWriteMask)
            }
        case "readsFromDepthBuffer":
            self.readsFromDepthBuffer = Bool(value) ?? self.readsFromDepthBuffer
        case "fresnelExponent":
            self.fresnelExponent = CGFloat(value) ?? self.fresnelExponent
        case "blendMode":
            if let blendMode = Int(value) {
                 self.blendMode = SCNBlendMode(rawValue: blendMode) ?? .alpha
            }
        default:
            break
        }
    }
    
    func toFREObject(nodeName: String? ) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.materials.Material", args: self.name)
            try ret?.setProp(name: "shininess", value: self.shininess)
            try ret?.setProp(name: "transparency", value: self.transparency)
            try ret?.setProp(name: "lightingModel", value: self.lightingModel.rawValue)
            try ret?.setProp(name: "isLitPerPixel", value: self.isLitPerPixel)
            try ret?.setProp(name: "isDoubleSided", value: self.isDoubleSided)
            try ret?.setProp(name: "fillMode", value: self.fillMode.rawValue)
            try ret?.setProp(name: "cullMode", value: self.cullMode.rawValue)
            try ret?.setProp(name: "transparencyMode", value: self.transparencyMode.rawValue)
            try ret?.setProp(name: "locksAmbientWithDiffuse", value: self.locksAmbientWithDiffuse)
            try ret?.setProp(name: "writesToDepthBuffer", value: self.writesToDepthBuffer)
            try ret?.setProp(name: "colorBufferWriteMask", value: self.colorBufferWriteMask.rawValue)
            try ret?.setProp(name: "readsFromDepthBuffer", value: self.readsFromDepthBuffer)
            try ret?.setProp(name: "fresnelExponent", value: self.fresnelExponent)
            try ret?.setProp(name: "blendMode", value: self.blendMode.rawValue)
            try ret?.setProp(name: "diffuse", value: diffuse.toFREObject(
                materialName: self.name, materialType: "diffuse", nodeName: nodeName)
            )
            try ret?.setProp(name: "ambient", value: ambient.toFREObject(
                materialName: self.name, materialType: "ambient", nodeName: nodeName)
            )
            try ret?.setProp(name: "specular", value: specular.toFREObject(
                materialName: self.name, materialType: "specular", nodeName: nodeName)
            )
            try ret?.setProp(name: "emission", value: emission.toFREObject(
                materialName: self.name, materialType: "emission", nodeName: nodeName)
            )
            try ret?.setProp(name: "transparent", value: transparent.toFREObject(
                materialName: self.name, materialType: "transparent", nodeName: nodeName)
            )
            try ret?.setProp(name: "reflective", value: reflective.toFREObject(
                materialName: self.name, materialType: "reflective", nodeName: nodeName)
            )
            try ret?.setProp(name: "multiply", value: multiply.toFREObject(
                materialName: self.name, materialType: "multiply", nodeName: nodeName)
            )
            try ret?.setProp(name: "normal", value: normal.toFREObject(
                materialName: self.name, materialType: "normal", nodeName: nodeName)
            )
            try ret?.setProp(name: "displacement", value: displacement.toFREObject(
                materialName: self.name, materialType: "displacement", nodeName: nodeName)
            )
            try ret?.setProp(name: "ambientOcclusion", value: ambientOcclusion.toFREObject(
                materialName: self.name, materialType: "ambientOcclusion", nodeName: nodeName)
            )
            try ret?.setProp(name: "selfIllumination", value: selfIllumination.toFREObject(
                materialName: self.name, materialType: "selfIllumination", nodeName: nodeName)
            )
            try ret?.setProp(name: "metalness", value: metalness.toFREObject(
                materialName: self.name, materialType: "metalness", nodeName: nodeName)
            )
            try ret?.setProp(name: "roughness", value: roughness.toFREObject(
                materialName: self.name, materialType: "roughness", nodeName: nodeName)
            )
            return ret
        } catch {
        }
        return nil
    }
}

public extension Array where Element == SCNMaterial {
    func toFREObject(nodeName: String?) -> FREArray? {
        do {
            let ret = try FREArray.init(className: "Vector.<com.tuarua.arane.materials.Material>",
                                        args: self.count)
            var cnt: UInt = 0
            for material in self {
                if let freMat = material.toFREObject(nodeName: nodeName) {
                    try ret.set(index: cnt, value: freMat)
                    cnt += 1
                }
            }
            return ret
        } catch {
        }
        return nil
    }
}
