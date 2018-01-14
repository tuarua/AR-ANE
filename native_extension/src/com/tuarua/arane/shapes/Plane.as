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
[RemoteClass(alias="com.tuarua.arane.shapes.Plane")]
public class Plane extends Geometry {
    private var _width:Number;
    private var _height:Number;
    private var _widthSegmentCount:int = 1;
    private var _heightSegmentCount:int = 1;
    private var _cornerRadius:Number = 0;
    private var _cornerSegmentCount:int = 10;

    public function Plane(width:Number = 1, height:Number = 1) {
        super("plane");
        this._width = width;
        this._height = height;
    }

    public function get width():Number {
        return _width;
    }

    public function set width(value:Number):void {
        _width = value;
        setANEvalue(type, "width", value);
    }

    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        _height = value;
        setANEvalue(type, "height", value);
    }

    public function get widthSegmentCount():int {
        return _widthSegmentCount;
    }

    public function set widthSegmentCount(value:int):void {
        _widthSegmentCount = value;
        setANEvalue(type, "widthSegmentCount", value);
    }

    public function get heightSegmentCount():int {
        return _heightSegmentCount;
    }

    public function set heightSegmentCount(value:int):void {
        _heightSegmentCount = value;
        setANEvalue(type, "heightSegmentCount", value);
    }

    public function get cornerRadius():Number {
        return _cornerRadius;
    }

    public function set cornerRadius(value:Number):void {
        _cornerRadius = value;
        setANEvalue(type, "cornerRadius", value);
    }

    public function get cornerSegmentCount():int {
        return _cornerSegmentCount;
    }

    public function set cornerSegmentCount(value:int):void {
        _cornerSegmentCount = value;
        setANEvalue(type, "cornerSegmentCount", value);
    }
}
}


