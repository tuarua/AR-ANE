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
[RemoteClass(alias="com.tuarua.arane.shapes.Tube")]
public class Tube extends Geometry {
    private var _innerRadius:Number;
    private var _outerRadius:Number;
    private var _height:Number;
    private var _radialSegmentCount:int = 48;
    private var _heightSegmentCount:int = 1;

    public function Tube(innerRadius:Number = 0.25, outerRadius:Number = 0.5, height:Number = 1) {
        super("tube");
        this._innerRadius = innerRadius;
        this._outerRadius = outerRadius;
        this._height = height;
    }

    public function get innerRadius():Number {
        return _innerRadius;
    }

    public function set innerRadius(value:Number):void {
        _innerRadius = value;
        setANEvalue(type, "innerRadius", value);
    }

    public function get outerRadius():Number {
        return _outerRadius;
    }

    public function set outerRadius(value:Number):void {
        _outerRadius = value;
        setANEvalue(type, "outerRadius", value);
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
