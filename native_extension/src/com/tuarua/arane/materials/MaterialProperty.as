/* Copyright 2018 Tua Rua Ltd.

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
    private var _isDefault:Boolean = true;
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

    /** private */
    public function MaterialProperty(materialName:String, type:String) {
        this._materialName = materialName;
        this._type = type;
    }

    /** Specifies the receiver's contents.
     *
     * This can be:
     * a color (ARGB uint)
     * bitmapData
     * a String path to an image
     *
     * */
    public function get contents():* {
        return _contents;
    }

    public function set contents(value:*):void {
        _isDefault = false;
        _contents = value;
        setANEvalue("contents", value);
    }

    /** Determines the receiver's intensity. This intensity is used to modulate the properties in several ways.
     * It dims the diffuse, specular and emission properties, it varies the bumpiness of the normal property and the
     * filter property is blended with white.
     * @default 1.0 */
    public function get intensity():Number {
        return _intensity;
    }

    public function set intensity(value:Number):void {
        if (value == _intensity) return;
        _isDefault = false;
        _intensity = value;
        setANEvalue("intensity", value);
    }

    /** Specifies the filter type to use when rendering the contents (specified in the `contents' property).
     *
     * The minification filter is used when to reduce the size of image data.
     *
     * @default FilterMode.linear */
    public function get minificationFilter():int {
        return _minificationFilter;
    }

    public function set minificationFilter(value:int):void {
        if (value == _minificationFilter) return;
        _isDefault = false;
        _minificationFilter = value;
        setANEvalue("minificationFilter", value);
    }

    /** Specifies the filter type to use when rendering the the contents (specified in the `contents' property).
     *
     * The magnification filter is used when to increase the size of image data.
     *
     * @default FilterMode.linear */
    public function get magnificationFilter():int {
        return _magnificationFilter;
    }

    public function set magnificationFilter(value:int):void {
        if (value == _magnificationFilter) return;
        _isDefault = false;
        _magnificationFilter = value;
        setANEvalue("magnificationFilter", value);
    }

    /** Specifies the mipmap filter to use during minification.
     * @default FilterMode.nearest */
    public function get mipFilter():int {
        return _mipFilter;
    }

    public function set mipFilter(value:int):void {
        if (value == _mipFilter) return;
        _isDefault = false;
        _mipFilter = value;
        setANEvalue("mipFilter", value);
    }

    /** Determines the receiver's wrap mode for the s texture coordinate.
     * @default WrapMode.clamp */
    public function get wrapS():int {
        return _wrapS;
    }

    public function set wrapS(value:int):void {
        if (value == _wrapS) return;
        _isDefault = false;
        _wrapS = value;
        setANEvalue("wrapS", value);
    }

    /** Determines the receiver's wrap mode for the t texture coordinate.
     * @default WrapMode.clamp */
    public function get wrapT():int {
        return _wrapT;
    }

    public function set wrapT(value:int):void {
        if (value == _wrapT) return;
        _isDefault = false;
        _wrapT = value;
        setANEvalue("wrapT", value);
    }

    /** Determines the receiver's mapping channel.
     *
     * Geometries potentially have multiple sources of texture coordinates. Every source has a unique
     * mapping channel index. The mapping channel allows to select which source of texture coordinates
     * is used to map the content of the receiver.
     *
     * @default 0 */
    public function get mappingChannel():int {
        return _mappingChannel;
    }

    public function set mappingChannel(value:int):void {
        if (value == _mappingChannel) return;
        _isDefault = false;
        _mappingChannel = value;
        setANEvalue("mappingChannel", value);
    }

    /** Specifies the receiver's max anisotropy.
     *
     * Anisotropic filtering reduces blur and preserves detail at extreme viewing angles.
     *
     * @default 1.0 */
    public function get maxAnisotropy():Number {
        return _maxAnisotropy;
    }

    public function set maxAnisotropy(value:Number):void {
        if (value == _maxAnisotropy) return;
        _isDefault = false;
        _maxAnisotropy = value;
        setANEvalue("maxAnisotropy", value);
    }

    /** @private */
    public function get materialName():String {
        return _materialName;
    }

    /** @private */
    public function set materialName(value:String):void {
        if (value == _materialName) return;
        _isDefault = false;
        _materialName = value;
    }

    /** @private */
    public function get nodeName():String {
        return _nodeName;
    }

    /** @private */
    public function set nodeName(value:String):void {
        if (value == _nodeName) return;
        _nodeName = value;
    }

    /** @private */
    private function setANEvalue(name:String, value:*):void {
        if (_nodeName && _materialName) {
            var theRet:* = ARANEContext.context.call("setMaterialPropertyProp", _materialName, _nodeName, _type, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** @private */
    public function get type():String {
        return _type;
    }

    /** @private */
    public function set type(value:String):void {
        _type = value;
    }

    /** @private */
    public function get isDefault():Boolean {
        return _isDefault;
    }
}
}
