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
[RemoteClass(alias="com.tuarua.arane.shapes.Sphere")]
public class Sphere extends Geometry {
    private var _radius:Number;
    private var _isGeodesic:Boolean = false;
    private var _segmentCount:int = 24;
    public function Sphere(radius: Number = 0.5) {
        super("sphere");
        this.radius = radius;
    }

    public function get radius():Number {
        return _radius;
    }

    public function set radius(value:Number):void {
        if (value == _radius) return;
        _radius = value;
        setANEvalue(type, "radius", value);
    }

    public function get isGeodesic():Boolean {
        return _isGeodesic;
    }

    public function set isGeodesic(value:Boolean):void {
        if (value == _isGeodesic) return;
        _isGeodesic = value;
        setANEvalue(type, "isGeodesic", value);
    }

    public function get segmentCount():int {
        return _segmentCount;
    }

    public function set segmentCount(value:int):void {
        if (value == _segmentCount) return;
        _segmentCount = value;
        setANEvalue(type, "segmentCount", value);
    }
}
}
