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
[RemoteClass(alias="com.tuarua.arkit.shapes.Capsule")]
public class Capsule extends Geometry {
    private var _capRadius:Number;
    private var _height:Number;
    private var _radialSegmentCount:int = 48;
    private var _heightSegmentCount:int = 1;
    private var _capSegmentCount:int = 24;

    /** Creates and returns a capsule with given radius and height.
     *
     * @param capRadius The radius of the capsule.
     * @param height The height of the capsule.
     *
     */
    public function Capsule(capRadius:Number = 0.5, height:Number = 2) {
        super("capsule");
        this._capRadius = capRadius;
        this._height = height;
    }

    /** The cap radius of the capsule.
     * @default 0.5 */
    public function get capRadius():Number {
        return _capRadius;
    }

    public function set capRadius(value:Number):void {
        if (value == _capRadius) return;
        _capRadius = value;
        setANEvalue(type, "capRadius", value);
    }

    /** The height of the capsule.
     * @default 0.5 */
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
     * @default 48 */
    public function get heightSegmentCount():int {
        return _heightSegmentCount;
    }

    public function set heightSegmentCount(value:int):void {
        if (value == _heightSegmentCount) return;
        _heightSegmentCount = value;
        setANEvalue(type, "heightSegmentCount", value);
    }

    /** The number of subdivisions in the cap.
     * @default 48 */
    public function get capSegmentCount():int {
        return _capSegmentCount;
    }

    public function set capSegmentCount(value:int):void {
        if (value == _capSegmentCount) return;
        _capSegmentCount = value;
        setANEvalue(type, "capSegmentCount", value);
    }
}
}
