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

package com.tuarua.arane.shapes {

public class Text extends Geometry {
    //private static const TYPE:String = "text";
    private var _string:String;
    private var _extrusionDepth:Number;
    private var _flatness:Number;
    private var _chamferRadius:Number;

    public function Text(string:String, extrusionDepth:Number) {
        super("text");
        this._string = string;
        this._extrusionDepth = extrusionDepth;
    }

    public function get string():String {
        return _string;
    }

    public function set string(value:String):void {
        _string = value;
        setANEvalue(type, "string", value);
    }

    public function get extrusionDepth():Number {
        return _extrusionDepth;
    }

    public function set extrusionDepth(value:Number):void {
        _extrusionDepth = value;
        setANEvalue(type, "extrusionDepth", value);
    }

    public function get flatness():Number {
        return _flatness;
    }

    public function set flatness(value:Number):void {
        _flatness = value;
        setANEvalue(type, "flatness", value);
    }

    public function get chamferRadius():Number {
        return _chamferRadius;
    }

    public function set chamferRadius(value:Number):void {
        _chamferRadius = value;
        setANEvalue(type, "chamferRadius", value);
    }
}
}
