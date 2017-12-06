// Copyright 2017 Tua Rua Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Additional Terms
//  No part, or derivative of this Air Native Extensions's code is permitted
//  to be sold as the basis of a commercially packaged Air Native Extension which
//  undertakes the same purpose as this software. That is an ARKit ANE for iOS.
//  All Rights Reserved. Tua Rua Ltd.

package com.tuarua.arane.shapes {
public class Pyramid extends Geometry {
    private static const TYPE:String = "pyramid";
    private var _width:Number;
    private var _height:Number;
    private var _length:Number;
    private var _widthSegmentCount:int = 1;
    private var _heightSegmentCount:int = 1;
    private var _lengthSegmentCount:int = 1;

    public function Pyramid(width:Number = 1, height:Number = 1, length:Number = 1) {
        super();
        this._width = width;
        this._height = height;
        this._length = length;

    }

    public function get width():Number {
        return _width;
    }

    public function set width(value:Number):void {
        _width = value;
        setANEvalue(TYPE, "width", value);
    }

    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        _height = value;
        setANEvalue(TYPE, "height", value);
    }

    public function get length():Number {
        return _length;
    }

    public function set length(value:Number):void {
        _length = value;
        setANEvalue(TYPE, "length", value);
    }

    public function get widthSegmentCount():int {
        return _widthSegmentCount;
    }

    public function set widthSegmentCount(value:int):void {
        _widthSegmentCount = value;
        setANEvalue(TYPE, "widthSegmentCount", value);
    }

    public function get heightSegmentCount():int {
        return _heightSegmentCount;
    }

    public function set heightSegmentCount(value:int):void {
        _heightSegmentCount = value;
        setANEvalue(TYPE, "heightSegmentCount", value);
    }

    public function get lengthSegmentCount():int {
        return _lengthSegmentCount;
    }

    public function set lengthSegmentCount(value:int):void {
        _lengthSegmentCount = value;
        setANEvalue(TYPE, "lengthSegmentCount", value);
    }
}
}
