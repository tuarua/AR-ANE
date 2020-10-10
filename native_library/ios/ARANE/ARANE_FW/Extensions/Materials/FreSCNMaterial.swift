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
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        self.init()
        self.name = fre.name
        
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

        self.shininess = fre.shininess
        self.transparency = fre.transparency
        self.lightingModel = LightingModel(rawValue: fre.lightingModel ?? "phong")
        self.isLitPerPixel = fre.isLitPerPixel
        self.isDoubleSided = fre.isDoubleSided
        self.fillMode = SCNFillMode(rawValue: fre.fillMode) ?? .fill
        self.cullMode = SCNCullMode(rawValue: fre.cullMode) ?? .back
        self.transparencyMode = SCNTransparencyMode(rawValue: fre.transparencyMode) ?? .default
        self.locksAmbientWithDiffuse = fre.locksAmbientWithDiffuse
        self.writesToDepthBuffer = fre.writesToDepthBuffer
        self.colorBufferWriteMask = SCNColorMask(rawValue: fre.colorBufferWriteMask)
        self.readsFromDepthBuffer = fre.readsFromDepthBuffer
        self.fresnelExponent = fre.fresnelExponent
        self.blendMode = SCNBlendMode(rawValue: fre.blendMode) ?? .alpha
    }
    
    func setMaterialPropertyProp(type: String, name: String, value: FREObject, queue: DispatchQueue) {
        switch type {
        case "diffuse":
            self.diffuse.setProp(name: name, value: value, queue: queue)
        case "ambient":
            self.ambient.setProp(name: name, value: value, queue: queue)
        case "specular":
            self.specular.setProp(name: name, value: value, queue: queue)
        case "emission":
            self.emission.setProp(name: name, value: value, queue: queue)
        case "transparent":
            self.transparent.setProp(name: name, value: value, queue: queue)
        case "reflective":
            self.reflective.setProp(name: name, value: value, queue: queue)
        case "multiply":
            self.multiply.setProp(name: name, value: value, queue: queue)
        case "normal":
            self.normal.setProp(name: name, value: value, queue: queue)
        case "displacement":
            self.displacement.setProp(name: name, value: value, queue: queue)
        case "ambientOcclusion":
            self.ambientOcclusion.setProp(name: name, value: value, queue: queue)
        case "selfIllumination":
            self.selfIllumination.setProp(name: name, value: value, queue: queue)
        case "metalness":
            self.metalness.setProp(name: name, value: value, queue: queue)
        case "roughness":
            self.roughness.setProp(name: name, value: value, queue: queue)
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
                self.lightingModel = LightingModel(rawValue: lightingModel)
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
        guard let fre = FreObjectSwift(className: "com.tuarua.arkit.materials.Material", args: self.name) else {
            return nil
        }
        fre.shininess = shininess
        fre.transparency = transparency
        fre.lightingModel = lightingModel.rawValue
        fre.isLitPerPixel = isLitPerPixel
        fre.isDoubleSided = isDoubleSided
        fre.fillMode = fillMode.rawValue
        fre.cullMode = cullMode.rawValue
        fre.transparencyMode = transparencyMode.rawValue
        fre.isDoubleSided = isDoubleSided
        fre.isDoubleSided = isDoubleSided
        fre.locksAmbientWithDiffuse = locksAmbientWithDiffuse
        fre.writesToDepthBuffer = writesToDepthBuffer
        fre.colorBufferWriteMask = colorBufferWriteMask.rawValue
        fre.readsFromDepthBuffer = readsFromDepthBuffer
        fre.fresnelExponent = fresnelExponent
        fre.blendMode = blendMode.rawValue
        
        fre.diffuse = diffuse.toFREObject(materialName: name, materialType: "diffuse", nodeName: nodeName)
        fre.ambient = ambient.toFREObject(materialName: name, materialType: "ambient", nodeName: nodeName)
        fre.specular = specular.toFREObject(materialName: name, materialType: "specular", nodeName: nodeName)
        fre.emission = emission.toFREObject(materialName: name, materialType: "emission", nodeName: nodeName)
        fre.transparent = transparent.toFREObject(materialName: name, materialType: "transparent", nodeName: nodeName)
        fre.reflective = reflective.toFREObject(materialName: name, materialType: "reflective", nodeName: nodeName)
        fre.multiply = multiply.toFREObject(materialName: name, materialType: "multiply", nodeName: nodeName)
        fre.normal = normal.toFREObject(materialName: name, materialType: "normal", nodeName: nodeName)
        fre.displacement = displacement.toFREObject(materialName: name, materialType: "displacement",
                                                    nodeName: nodeName)
        fre.ambientOcclusion = ambientOcclusion.toFREObject(materialName: name, materialType: "ambientOcclusion",
                                                            nodeName: nodeName)
        
        fre.metalness = metalness.toFREObject(materialName: name, materialType: "metalness", nodeName: nodeName)
        fre.roughness = roughness.toFREObject(materialName: name, materialType: "roughness", nodeName: nodeName)
        fre.selfIllumination = selfIllumination.toFREObject(materialName: name, materialType: "selfIllumination",
                                                            nodeName: nodeName)
        
        return fre.rawValue
    }
}

public extension Array where Element == SCNMaterial {
    func toFREObject(nodeName: String?) -> FREObject? {
        return FREArray(className: "com.tuarua.arkit.materials.Material",
                        length: count, fixed: true,
                        items: compactMap { $0.toFREObject(nodeName: nodeName) })?.rawValue
    }
}
