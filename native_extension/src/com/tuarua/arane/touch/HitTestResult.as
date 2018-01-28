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
import com.tuarua.arane.Node;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

[RemoteClass(alias="com.tuarua.arane.touch.HitTestResult")]
public class HitTestResult {
    private var _node:Node;
    private var _geometryIndex:int;
    private var _faceIndex:int;
    private var _localCoordinates:Vector3D;
    private var _worldCoordinates:Vector3D;
    private var _localNormal:Vector3D;
    private var _modelTransform:Matrix3D;
    private var _worldNormal:Vector3D;
    private var _boneNode:Node;
    public function HitTestResult(node:Node, geometryIndex:int, faceIndex:int, localCoordinates:Vector3D,
                                  worldCoordinates:Vector3D, localNormal:Vector3D, worldNormal:Vector3D,
                                  modelTransform:Matrix3D, boneNode:Node = null) {
        _node = node;
        _geometryIndex = geometryIndex;
        _faceIndex = faceIndex;
        _localCoordinates = localCoordinates;
        _worldCoordinates = worldCoordinates;
        _localNormal = localNormal;
        _worldNormal = worldNormal;
        _modelTransform = modelTransform;
        _boneNode = boneNode;
    }

    public function get node():Node {
        return _node;
    }

    public function get geometryIndex():int {
        return _geometryIndex;
    }

    public function get faceIndex():int {
        return _faceIndex;
    }

    public function get localCoordinates():Vector3D {
        return _localCoordinates;
    }

    public function get worldCoordinates():Vector3D {
        return _worldCoordinates;
    }

    public function get localNormal():Vector3D {
        return _localNormal;
    }

    public function get worldNormal():Vector3D {
        return _worldNormal;
    }

    public function get modelTransform():Matrix3D {
        return _modelTransform;
    }

    public function get boneNode():Node {
        return _boneNode;
    }
}
}