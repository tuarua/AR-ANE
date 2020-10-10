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

package com.tuarua.arkit.physics {

[RemoteClass(alias="com.tuarua.arkit.physics.PhysicsShape")]
public class PhysicsShape {
    private var _geometry:*;
    private var _options:PhysicsShapeOption;

    /**
     * @param geometry
     * @param options
     */
    public function PhysicsShape(geometry:*, options:PhysicsShapeOption = null) {
        this._geometry = geometry;
        this._options = options;
    }

    /** geometry */
    public function get geometry():* {
        return _geometry;
    }
    /** options */
    public function get options():PhysicsShapeOption {
        return _options;
    }
}
}
