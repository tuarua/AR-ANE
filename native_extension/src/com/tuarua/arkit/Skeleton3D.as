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

/** The skeleton of a human body that ARKit tracks in 3D space. */
public class Skeleton3D {
    private var _jointLocalTransforms:Vector.<Matrix3D>;
    private var _jointModelTransforms:Vector.<Matrix3D>;

    public function Skeleton3D(jointLocalTransforms:Vector.<Matrix3D>, jointModelTransforms:Vector.<Matrix3D>) {
        this._jointLocalTransforms = jointLocalTransforms;
        this._jointModelTransforms = jointModelTransforms;
    }

    /** The local space joint data for each joint. */
    public function get jointLocalTransforms():Vector.<Matrix3D> {
        return _jointLocalTransforms;
    }

    /** The model space transforms for each joint. */
    public function get jointModelTransforms():Vector.<Matrix3D> {
        return _jointModelTransforms;
    }
}
}