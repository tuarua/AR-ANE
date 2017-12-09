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

package com.tuarua.arane.materials {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;
import com.tuarua.utils.GUID;

public class Material {
    private var _nodeId:String;
    private var _id:String = GUID.create();
    private var _diffuse:MaterialProperty = new MaterialProperty(_id, "diffuse");
    private var _ambient:MaterialProperty = new MaterialProperty(_id, "ambient");
    private var _specular:MaterialProperty = new MaterialProperty(_id, "sspecular");
    private var _emission:MaterialProperty = new MaterialProperty(_id, "emission");
    private var _transparent:MaterialProperty = new MaterialProperty(_id, "transparent");
    private var _reflective:MaterialProperty = new MaterialProperty(_id, "reflective");
    private var _multiply:MaterialProperty = new MaterialProperty(_id, "multiply");
    private var _normal:MaterialProperty = new MaterialProperty(_id, "normal");
    private var _displacement:MaterialProperty = new MaterialProperty(_id, "displacement");
    private var _ambientOcclusion:MaterialProperty = new MaterialProperty(_id, "ambientOcclusion");
    private var _selfIllumination:MaterialProperty = new MaterialProperty(_id, "selfIllumination");
    private var _metalness:MaterialProperty = new MaterialProperty(_id, "metalness");
    private var _roughness:MaterialProperty = new MaterialProperty(_id, "roughness");
    private var _shininess:Number = 1.0;
    private var _transparency:Number = 1.0;
    private var _lightingModel:String = "phong"; // blinn, lambert, constant, physicallyBased
    private var _isLitPerPixel:Boolean = true;
    private var _isDoubleSided:Boolean = false;
    private var _fillMode:int = 0;
    private var _cullMode:int = 0;
    private var _transparencyMode:int = 4;
    private var _locksAmbientWithDiffuse:Boolean = true;
    private var _writesToDepthBuffer:Boolean = true;
    private var _colorBufferWriteMask:int = ColorMask.all;
    private var _readsFromDepthBuffer:Boolean = true;
    private var _fresnelExponent:Number = 0.0;
    private var _blendMode:int = BlendMode.alpha;

    public function Material() {
    }

    public function get id():String {
        return _id;
    }

    public function get diffuse():MaterialProperty {
        return _diffuse;
    }

    public function get ambient():MaterialProperty {
        return _ambient;
    }

    public function get specular():MaterialProperty {
        return _specular;
    }

    public function get emission():MaterialProperty {
        return _emission;
    }

    public function get transparent():MaterialProperty {
        return _transparent;
    }

    public function get reflective():MaterialProperty {
        return _reflective;
    }

    public function get multiply():MaterialProperty {
        return _multiply;
    }

    public function get normal():MaterialProperty {
        return _normal;
    }

    public function get displacement():MaterialProperty {
        return _displacement;
    }

    public function get ambientOcclusion():MaterialProperty {
        return _ambientOcclusion;
    }

    public function get selfIllumination():MaterialProperty {
        return _selfIllumination;
    }

    public function get metalness():MaterialProperty {
        return _metalness;
    }

    public function get roughness():MaterialProperty {
        return _roughness;
    }

    public function get shininess():Number {
        return _shininess;
    }

    public function set shininess(value:Number):void {
        _shininess = value;
        setANEvalue("shininess", value);
    }

    public function get transparency():Number {
        return _transparency;
    }

    public function set transparency(value:Number):void {
        _transparency = value;
        setANEvalue("transparency", value);
    }

    public function get lightingModel():String {
        return _lightingModel;
    }

    public function set lightingModel(value:String):void {
        _lightingModel = value;
        setANEvalue("lightingModel", value);
    }

    public function get isLitPerPixel():Boolean {
        return _isLitPerPixel;
    }

    public function set isLitPerPixel(value:Boolean):void {
        _isLitPerPixel = value;
        setANEvalue("isLitPerPixel", value);
    }

    public function get isDoubleSided():Boolean {
        return _isDoubleSided;
    }

    public function set isDoubleSided(value:Boolean):void {
        _isDoubleSided = value;
        setANEvalue("isDoubleSided", value);
    }

    public function get fillMode():int {
        return _fillMode;
    }

    public function set fillMode(value:int):void {
        _fillMode = value;
        setANEvalue("fillMode", value);
    }

    public function get cullMode():int {
        return _cullMode;
    }

    public function set cullMode(value:int):void {
        _cullMode = value;
        setANEvalue("cullMode", value);
    }

    public function get transparencyMode():int {
        return _transparencyMode;
    }

    public function set transparencyMode(value:int):void {
        _transparencyMode = value;
        setANEvalue("transparencyMode", value);
    }

    public function get locksAmbientWithDiffuse():Boolean {
        return _locksAmbientWithDiffuse;
    }

    public function set locksAmbientWithDiffuse(value:Boolean):void {
        _locksAmbientWithDiffuse = value;
        setANEvalue("locksAmbientWithDiffuse", value);
    }

    public function get writesToDepthBuffer():Boolean {
        return _writesToDepthBuffer;
    }

    public function set writesToDepthBuffer(value:Boolean):void {
        _writesToDepthBuffer = value;
        setANEvalue("writesToDepthBuffer", value);
    }

    public function get colorBufferWriteMask():int {
        return _colorBufferWriteMask;
    }

    public function set colorBufferWriteMask(value:int):void {
        _colorBufferWriteMask = value;
        setANEvalue("colorBufferWriteMask", value);
    }

    public function get readsFromDepthBuffer():Boolean {
        return _readsFromDepthBuffer;
    }

    public function set readsFromDepthBuffer(value:Boolean):void {
        _readsFromDepthBuffer = value;
        setANEvalue("readsFromDepthBuffer", value);
    }

    public function get fresnelExponent():Number {
        return _fresnelExponent;
    }

    public function set fresnelExponent(value:Number):void {
        _fresnelExponent = value;
        setANEvalue("fresnelExponent", value);
    }

    public function get blendMode():int {
        return _blendMode;
    }

    public function set blendMode(value:int):void {
        _blendMode = value;
        setANEvalue("blendMode", value);
    }

    public function get nodeId():String {
        return _nodeId;
    }

    public function set nodeId(value:String):void {
        _nodeId = value;
        _diffuse.nodeId = _nodeId;
        _ambient.nodeId = _nodeId;
        _specular.nodeId = _nodeId;
        _emission.nodeId = _nodeId;
        _transparent.nodeId = _nodeId;
        _reflective.nodeId = _nodeId;
        _multiply.nodeId = _nodeId;
        _normal.nodeId = _nodeId;
        _displacement.nodeId = _nodeId;
        _ambientOcclusion.nodeId = _nodeId;
        _selfIllumination.nodeId = _nodeId;
        _metalness.nodeId = _nodeId;
        _roughness.nodeId = _nodeId;
    }

    private function setANEvalue(name:String, value:*):void {
        if (_nodeId) {
            var theRet:* = ARANEContext.context.call("setMaterialProp", _id, _nodeId, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }
}
}
