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

package com.tuarua.arkit.shapes {
[RemoteClass(alias="com.tuarua.arane.shapes.Cylinder")]
public class Cylinder extends Geometry {
    private var _radius:Number;
    private var _height:Number;
    private var _radialSegmentCount:int = 48;
    private var _heightSegmentCount:int = 1;

    /** Creates and returns a cylinder with given radius and height.
     * @param radius The radius of the cylinder.
     * @param height The height of the cylinder.
     */
    public function Cylinder(radius:Number = 0.5, height:Number = 1) {
        super("cylinder");
        this._radius = radius;
        this._height = height;
    }

    /** The radius of the cylinder.
     * @default 0.5 */
    public function get radius():Number {
        return _radius;
    }

    public function set radius(value:Number):void {
        if (value == _radius) return;
        _radius = value;
        setANEvalue(type, "radius", value);
    }

    /** The height of the cylinder.
     * @default 1 */
    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        if (value == _height) return;
        _height = value;
        setANEvalue(type, "height", value);
    }

    /** The number of subdivisions along the radial coordinate.
     * @default 48 */
    public function get radialSegmentCount():int {
        return _radialSegmentCount;
    }

    public function set radialSegmentCount(value:int):void {
        if (value == _radialSegmentCount) return;
        _radialSegmentCount = value;
        setANEvalue(type, "radialSegmentCount", value);
    }

    /** The number of subdivisions along the Y axis.
     * @default 1 */
    public function get heightSegmentCount():int {
        return _heightSegmentCount;
    }

    public function set heightSegmentCount(value:int):void {
        if (value == _heightSegmentCount) return;
        _heightSegmentCount = value;
        setANEvalue(type, "heightSegmentCount", value);
    }
}
}
