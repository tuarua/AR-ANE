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
[RemoteClass(alias="com.tuarua.arkit.shapes.Box")]
public class Box extends Geometry {
    private var _width:Number;
    private var _height:Number;
    private var _length:Number;
    private var _chamferRadius:Number;
    private var _widthSegmentCount:int = 1;
    private var _heightSegmentCount:int = 1;
    private var _lengthSegmentCount:int = 1;
    private var _chamferSegmentCount:int = 5;

    /** Creates and returns a box with given width, height, length and chamfer radius.
     *
     * @param width The width of the box.
     * @param height The height of the box.
     * @param length The length of the box.
     * @param chamferRadius The chamfer radius of the box.
     */
    public function Box(width:Number = 1, height:Number = 1, length:Number = 1, chamferRadius:Number = 0) {
        super("box");
        this._width = width;
        this._height = height;
        this._length = length;
        this._chamferRadius = chamferRadius;
    }

    /** The width of the box.
     * @default 1 */
    public function get width():Number {
        return _width;
    }

    public function set width(value:Number):void {
        if (value == _width) return;
        _width = value;
        setANEvalue(type, "width", value);
    }

    /** The height of the box.
     * @default 1 */
    public function get height():Number {
        return _height;
    }

    public function set height(value:Number):void {
        if (value == _height) return;
        _height = value;
        setANEvalue(type, "height", value);
    }

    /** The length of the box.
     * @default 1 */
    public function get length():Number {
        return _length;
    }

    public function set length(value:Number):void {
        if (value == _length) return;
        _length = value;
        setANEvalue(type, "length", value);
    }

    /** The chamfer radius.
     * @default 0 */
    public function get chamferRadius():Number {
        return _chamferRadius;
    }

    public function set chamferRadius(value:Number):void {
        if (value == _chamferRadius) return;
        _chamferRadius = value;
        setANEvalue(type, "chamferRadius", value);
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

    /** The number of subdivisions along the Z axis.
     * @default 1 */
    public function get lengthSegmentCount():int {
        return _lengthSegmentCount;
    }

    public function set lengthSegmentCount(value:int):void {
        if (value == _lengthSegmentCount) return;
        _lengthSegmentCount = value;
        setANEvalue(type, "lengthSegmentCount", value);
    }

    /** The number of chamfer subdivisions.
     * @default 5 */
    public function get chamferSegmentCount():int {
        return _chamferSegmentCount;
    }

    public function set chamferSegmentCount(value:int):void {
        if (value == _chamferSegmentCount) return;
        _chamferSegmentCount = value;
        setANEvalue(type, "chamferSegmentCount", value);
    }

}
}

