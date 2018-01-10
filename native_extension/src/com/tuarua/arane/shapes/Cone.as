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
public class Cone extends Geometry {
    private var _topRadius:Number;
    private var _bottomRadius:Number;
    private var _height:Number;
    private var _radialSegmentCount:int = 48;
    private var _heightSegmentCount:int = 1;

    public function Cone(topRadius:Number = 0, bottomRadius:Number = 0.5, height:Number = 1) {
        super("cone");
        this._topRadius = topRadius;
        this._bottomRadius = bottomRadius;
        this._height = height;
    }

    public function get topRadius():Number {
        return _topRadius;
    }

    public function set topRadius(value:Number):void {
        _topRadius = value;
        setANEvalue(type, "topRadius", value);
    }

    public function get bottomRadius():Number {
        return _bottomRadius;
    }

    public function set bottomRadius(value:Number):void {
        _bottomRadius = value;
        setANEvalue(type, "bottomRadius", value);
    }

    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        _height = value;
        setANEvalue(type, "height", value);
    }

    public function get radialSegmentCount():int {
        return _radialSegmentCount;
    }

    public function set radialSegmentCount(value:int):void {
        _radialSegmentCount = value;
        setANEvalue(type, "radialSegmentCount", value);
    }

    public function get heightSegmentCount():int {
        return _heightSegmentCount;
    }

    public function set heightSegmentCount(value:int):void {
        _heightSegmentCount = value;
        setANEvalue(type, "heightSegmentCount", value);
    }
}
}
