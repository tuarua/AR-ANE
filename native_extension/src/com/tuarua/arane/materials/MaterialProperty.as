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
[RemoteClass(alias="com.tuarua.arane.materials.MaterialProperty")]
public class MaterialProperty {
    private var _type:String;
    private var _nodeName:String;
    private var _materialName:String;
    private var _contents:* = null;
    private var _intensity:Number = 1.0;
    private var _minificationFilter:int = FilterMode.linear;
    private var _magnificationFilter:int = FilterMode.linear;
    private var _mipFilter:int = FilterMode.nearest;
    private var _wrapS:int = WrapMode.clamp;
    private var _wrapT:int = WrapMode.clamp;
    private var _mappingChannel:int = 0;
    private var _maxAnisotropy:Number = 1.0;

    //noinspection ReservedWordAsName
    public function MaterialProperty(materialName:String, type:String) {
        this._materialName = materialName;
        this._type = type;
    }

    public function get contents():* {
        return _contents;
    }

    public function set contents(value:*):void {
        _contents = value;
        setANEvalue("contents", value);
    }

    public function get intensity():Number {
        return _intensity;
    }

    public function set intensity(value:Number):void {
        _intensity = value;
        setANEvalue("intensity", value);
    }

    public function get minificationFilter():int {
        return _minificationFilter;
    }

    public function set minificationFilter(value:int):void {
        _minificationFilter = value;
        setANEvalue("minificationFilter", value);
    }

    public function get magnificationFilter():int {
        return _magnificationFilter;
    }

    public function set magnificationFilter(value:int):void {
        _magnificationFilter = value;
        setANEvalue("magnificationFilter", value);
    }

    public function get mipFilter():int {
        return _mipFilter;
    }

    public function set mipFilter(value:int):void {
        _mipFilter = value;
        setANEvalue("mipFilter", value);
    }

    public function get wrapS():int {
        return _wrapS;
    }

    public function set wrapS(value:int):void {
        _wrapS = value;
        setANEvalue("wrapS", value);
    }

    public function get wrapT():int {
        return _wrapT;
    }

    public function set wrapT(value:int):void {
        _wrapT = value;
        setANEvalue("wrapT", value);
    }

    public function get mappingChannel():int {
        return _mappingChannel;
    }

    public function set mappingChannel(value:int):void {
        _mappingChannel = value;
        setANEvalue("mappingChannel", value);
    }

    public function get maxAnisotropy():Number {
        return _maxAnisotropy;
    }

    public function set maxAnisotropy(value:Number):void {
        _maxAnisotropy = value;
        setANEvalue("maxAnisotropy", value);
    }

    public function get materialName():String {
        return _materialName;
    }

    public function set materialName(value:String):void {
        _materialName = value;
    }

    public function get nodeName():String {
        return _nodeName;
    }

    public function set nodeName(value:String):void {
        _nodeName = value;
    }

    //noinspection ReservedWordAsName
    private function setANEvalue(name:String, value:*):void {
        if (_nodeName && _materialName) {
            var theRet:* = ARANEContext.context.call("setMaterialPropertyProp", _materialName, _nodeName, _type, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }
}
}


/*

/!*!
 @property contentsTransform
 @abstract Determines the receiver's contents transform. Animatable.
 *!/
open var contentsTransform: SCNMatrix4

/!*!
 @property textureComponents
 @abstract Specifies the texture components to sample in the shader. Defaults to SCNColorMaskRed for displacement property, and to SCNColorMaskAll for other properties.
 @discussion Use this property to when using a texture that combine multiple informations in the different texture components. For example if you pack the roughness in red and metalness in blue etc... You can specify what component to use from the texture for this given material property. This property is only supported by Metal renderers.
 *!/
@available(iOS 11.0, *)
open var textureComponents: SCNColorMask
*/
