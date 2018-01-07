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
public class Torus extends Geometry {
    //private static const TYPE:String = "torus";
    private var _ringRadius:Number;
    private var _pipeRadius:Number;
    private var _ringSegmentCount:int = 48;
    private var _pipeSegmentCount:int = 24;

    public function Torus(ringRadius:Number = 0.25, pipeRadius:Number = 0.5) {
        super("torus");
        this._ringRadius = ringRadius;
        this._pipeRadius = pipeRadius;
    }

    public function get ringRadius():Number {
        return _ringRadius;
    }

    public function set ringRadius(value:Number):void {
        _ringRadius = value;
        setANEvalue(type, "ringRadius", value);
    }

    public function get pipeRadius():Number {
        return _pipeRadius;
    }

    public function set pipeRadius(value:Number):void {
        _pipeRadius = value;
        setANEvalue(type, "pipeRadius", value);
    }

    public function get ringSegmentCount():int {
        return _ringSegmentCount;
    }

    public function set ringSegmentCount(value:int):void {
        _ringSegmentCount = value;
        setANEvalue(type, "ringSegmentCount", value);
    }

    public function get pipeSegmentCount():int {
        return _pipeSegmentCount;
    }

    public function set pipeSegmentCount(value:int):void {
        _pipeSegmentCount = value;
        setANEvalue(type, "pipeSegmentCount", value);
    }
}
}
