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
[RemoteClass(alias="com.tuarua.arane.shapes.Plane")]
public class Plane extends Geometry {
    private var _width:Number;
    private var _height:Number;
    private var _widthSegmentCount:int = 1;
    private var _heightSegmentCount:int = 1;
    private var _cornerRadius:Number = 0;
    private var _cornerSegmentCount:int = 10;

    /** Creates and returns a plane with given width and height.
     *
     * @param width The width of the plane.
     * @param height The height of the plane.
     *
     */
    public function Plane(width:Number = 1, height:Number = 1) {
        super("plane");
        this._width = width;
        this._height = height;
    }

    /** The plane extent along the X axis.
     * @default 1 */
    public function get width():Number {
        return _width;
    }

    public function set width(value:Number):void {
        if (value == _width) return;
        _width = value;
        setANEvalue(type, "width", value);
    }

    /** The plane extent along the Y axis.
     * @default 1 */
    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        if (value == _height) return;
        _height = value;
        setANEvalue(type, "height", value);
    }

    /** The number of subdivisions along the X axis.
     * @default 1 */
    public function get widthSegmentCount():int {
        return _widthSegmentCount;
    }

    public function set widthSegmentCount(value:int):void {
        if (value == _widthSegmentCount) return;
        _widthSegmentCount = value;
        setANEvalue(type, "widthSegmentCount", value);
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

    /** The corner radius.
     * @default 0 */
    public function get cornerRadius():Number {
        return _cornerRadius;
    }

    public function set cornerRadius(value:Number):void {
        if (value == _cornerRadius) return;
        _cornerRadius = value;
        setANEvalue(type, "cornerRadius", value);
    }

    /** The number of subdivisions for the rounded corners.
     * @default 10 */
    public function get cornerSegmentCount():int {
        return _cornerSegmentCount;
    }

    public function set cornerSegmentCount(value:int):void {
        if (value == _cornerSegmentCount) return;
        _cornerSegmentCount = value;
        setANEvalue(type, "cornerSegmentCount", value);
    }
}
}


