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

package com.tuarua.arane.touch {
import com.tuarua.arane.Anchor;

import flash.geom.Matrix3D;

[RemoteClass(alias="com.tuarua.arane.touch.ARHitTestResult")]
public class ARHitTestResult {
    private var _type:int;
    private var _distance:Number;
    private var _localTransform:Matrix3D;
    private var _worldTransform:Matrix3D;
    private var _anchor:Anchor;

    public function ARHitTestResult(type:int, distance:Number, localTransform:Matrix3D, worldTransform:Matrix3D,
                                    anchor:Anchor = null) {
        _type = type;
        _distance = distance;
        _localTransform = localTransform;
        _worldTransform = worldTransform;
        _anchor = anchor;
    }

    public function get type():int {
        return _type;
    }

    public function get distance():Number {
        return _distance;
    }

    public function get localTransform():Matrix3D {
        return _localTransform;
    }

    public function get worldTransform():Matrix3D {
        return _worldTransform;
    }

    public function get anchor():Anchor {
        return _anchor;
    }

}
}