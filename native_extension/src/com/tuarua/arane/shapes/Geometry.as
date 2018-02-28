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

package com.tuarua.arane.shapes {
import com.tuarua.ARANEContext;
import com.tuarua.arane.materials.Material;
import com.tuarua.fre.ANEError;

// TODO implement other props/methods https://developer.apple.com/documentation/scenekit/scngeometry
[RemoteClass(alias="com.tuarua.arane.shapes.Geometry")]
public class Geometry {
    public var nodeName:String;
    private var _materials:Vector.<Material> = new Vector.<Material>();
    protected var _subdivisionLevel:int = 0;
    protected var type:String = "geometry";

    /** @private */
    public function Geometry(type:String) {
        this.type = type;
    }

    /** @private */
    protected function setANEvalue(type:String, name:String, value:*):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("setGeometryProp", type, nodeName, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** Determines the first material of the geometry. Returns nil if the geometry has no material. */
    public function get firstMaterial():Material {
        if (_materials.length == 0) {
            _materials.push(new Material());
            setMaterialsNodeName();
        }
        return _materials[0];
    }

    /** Specifies the receiver's materials array. */
    public function get materials():Vector.<Material> {
        setMaterialsNodeName();
        return _materials;
    }

    public function set materials(value:Vector.<Material>):void {
        _materials = value;
        setANEvalue(type, "materials", value);
    }

    /** @private */
    private function setMaterialsNodeName():void {
        for each (var material:Material in _materials) {
            if (material) {
                material.nodeName = nodeName;
            }
        }
    }

    /** Specifies the subdivision level of the receiver.
     * @default 0 */
    public function get subdivisionLevel():int {
        return _subdivisionLevel;
    }

    public function set subdivisionLevel(value:int):void {
        if (value == _subdivisionLevel) return;
        _subdivisionLevel = value;
        setANEvalue(type, "subdivisionLevel", value);
    }

}
}
