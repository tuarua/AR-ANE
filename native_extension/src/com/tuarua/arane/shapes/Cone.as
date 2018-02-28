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
[RemoteClass(alias="com.tuarua.arane.shapes.Cone")]
public class Cone extends Geometry {
    private var _topRadius:Number;
    private var _bottomRadius:Number;
    private var _height:Number;
    private var _radialSegmentCount:int = 48;
    private var _heightSegmentCount:int = 1;

    /** Creates and returns a cone with given top radius, bottom radius and height.
     *
     * @param topRadius The radius at the top of the cone.
     * @param bottomRadius The radius at the bottom of the cone.
     * @param height The height of the cone.
     */
    public function Cone(topRadius:Number = 0, bottomRadius:Number = 0.5, height:Number = 1) {
        super("cone");
        this._topRadius = topRadius;
        this._bottomRadius = bottomRadius;
        this._height = height;
    }

    /** The radius at the top of the cone.
     * @default 0 */
    public function get topRadius():Number {
        return _topRadius;
    }

    public function set topRadius(value:Number):void {
        if (value == _topRadius) return;
        _topRadius = value;
        setANEvalue(type, "topRadius", value);
    }

    /** The radius at the bottom of the cone.
     * @default 0.5 */
    public function get bottomRadius():Number {
        return _bottomRadius;
    }

    public function set bottomRadius(value:Number):void {
        if (value == _bottomRadius) return;
        _bottomRadius = value;
        setANEvalue(type, "bottomRadius", value);
    }

    /** The height of the cone.
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
