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
public class Shape extends Geometry {
    private var _url:String;
    private var _extrusionDepth:Number = 0.0;
    private var _chamferRadius:Number = 0.0;
    private var _flatness:Number = 0.6;
    private var _chamferMode:int = ChamferMode.both;

    //private var _chamferProfile:String; //TODO


    /** Creates and returns a 3D representation of the given shape with the given extrusion depth.
     * @param url The cubic Bezier spline to extrude.
     */
    public function Shape(url:String) {
        super("shape");
        _url = url;
    }

    /** The path defining the shape to be rendered.
     * @default null */
    public function get url():String {
        return _url;
    }

    public function set url(value:String):void {
        _url = value;
        setANEvalue(type, "url", value);
    }

    /** The extrusion depth.
     * @default 0.0 */
    public function get extrusionDepth():Number {
        return _extrusionDepth;
    }

    public function set extrusionDepth(value:Number):void {
        if (value == _extrusionDepth) return;
        _extrusionDepth = value;
        setANEvalue(type, "extrusionDepth", value);
    }

    /** he chamfer radius.
     * @default 0 */
    public function get chamferRadius():Number {
        return _chamferRadius;
    }

    public function set chamferRadius(value:Number):void {
        if (value == _chamferRadius) return;
        _chamferRadius = value;
        setANEvalue(type, "chamferRadius", value);
    }

    /** The sides of the text that are chamfered.
     * @default 0 */
    public function get chamferMode():int {
        return _chamferMode;
    }

    public function set chamferMode(value:int):void {
        if (value == _chamferMode) return;
        _chamferMode = value;
        setANEvalue(type, "chamferMode", value);
    }

    /** Specifies the accuracy (or smoothness) with which fonts are rendered.
     * @default 0.6 */
    public function get flatness():Number {
        return _flatness;
    }

    public function set flatness(value:Number):void {
        if (value == _flatness) return;
        _flatness = value;
        setANEvalue(type, "flatness", value);
    }
}
}
