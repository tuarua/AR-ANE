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
[RemoteClass(alias="com.tuarua.arane.shapes.Torus")]
public class Torus extends Geometry {
    private var _ringRadius:Number;
    private var _pipeRadius:Number;
    private var _ringSegmentCount:int = 48;
    private var _pipeSegmentCount:int = 24;

    /** Creates and returns a torus with given ring radius and pipe radius.
     * @param ringRadius The radius of the ring.
     * @param pipeRadius The radius of the pipe.
     */
    public function Torus(ringRadius:Number = 0.25, pipeRadius:Number = 0.5) {
        super("torus");
        this._ringRadius = ringRadius;
        this._pipeRadius = pipeRadius;
    }

    /** The radius of the torus ring.
     * @default 0.5 */
    public function get ringRadius():Number {
        return _ringRadius;
    }

    public function set ringRadius(value:Number):void {
        if (value == _ringRadius) return;
        _ringRadius = value;
        setANEvalue(type, "ringRadius", value);
    }

    /** The radius of the torus pipe.
     * @default 0.25 */
    public function get pipeRadius():Number {
        return _pipeRadius;
    }

    public function set pipeRadius(value:Number):void {
        if (value == _pipeRadius) return;
        _pipeRadius = value;
        setANEvalue(type, "pipeRadius", value);
    }

    /** The number of subdivisions of the ring.
     * @default 48 */
    public function get ringSegmentCount():int {
        return _ringSegmentCount;
    }

    public function set ringSegmentCount(value:int):void {
        if (value == _ringSegmentCount) return;
        _ringSegmentCount = value;
        setANEvalue(type, "ringSegmentCount", value);
    }

    /** The number of subdivisions of the pipe.
     * @default 24 */
    public function get pipeSegmentCount():int {
        return _pipeSegmentCount;
    }

    public function set pipeSegmentCount(value:int):void {
        if (value == _pipeSegmentCount) return;
        _pipeSegmentCount = value;
        setANEvalue(type, "pipeSegmentCount", value);
    }
}
}
