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

package com.tuarua.arkit {
import flash.geom.Matrix3D;
[RemoteClass(alias="com.tuarua.arkit.Anchor")]
public class Anchor {
    private var _id:String;
    private var _transform:Matrix3D;
    private var _sessionId:String;

    public function Anchor(id:String = null, sessionId:String = null, transform:Matrix3D = null) {
        if (id) {
            this._id = id;
        }
        if (sessionId) {
            this._sessionId = sessionId;
        }
        if (transform) {
            this._transform = transform;
        }

    }

    public function get id():String {
        return _id;
    }

    public function get transform():Matrix3D {
        return _transform;
    }

    public function set transform(value:Matrix3D):void {
        _transform = value;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get sessionId():String {
        return _sessionId;
    }

    public function set sessionId(value:String):void {
        _sessionId = value;
    }
}
}
