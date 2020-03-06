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
import com.tuarua.arkit.materials.MaterialProperty;
import com.tuarua.arkit.physics.PhysicsWorld;

public class Scene {
    /** @private */
    private var _isInited:Boolean = false;
    private var _lightingEnvironment:MaterialProperty = new MaterialProperty("lightingEnvironment", "lightingEnvironment");
    private var _rootNode:Node = new Node(null, "sceneRoot");
    private var _physicsWorld:PhysicsWorld = new PhysicsWorld();

    /** @private */
    public function Scene() {
    }

    /** @private */
    public function init():void {
        _lightingEnvironment.nodeName = "sceneRoot";
        _isInited = true;
    }

    /** @private */
    private function initCheck():void {
        if (!_isInited) {
            throw new Error("You need to init first");
        }
    }

    /** lighting environment */
    public function get lightingEnvironment():MaterialProperty {
        return _lightingEnvironment;
    }

    /** root node */
    public function get rootNode():Node {
        return _rootNode;
    }

    /** physics world */
    public function get physicsWorld():PhysicsWorld {
        return _physicsWorld;
    }

}
}
