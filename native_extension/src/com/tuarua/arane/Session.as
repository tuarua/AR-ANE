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

package com.tuarua.arane {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.geom.Matrix3D;

import flash.geom.Vector3D;

public class Session {
    /** private */
    private var _isRunning:Boolean = false;

    /** private */
    public function Session() {
    }

    /** Runs the session with the provided configuration and options.
     *
     * <p>Calling run on a session that has already started will
     * transition immediately to using the new configuration. Options
     * can be used to alter the default behavior when transitioning configurations.</p>
     *
     * @param configuration
     * @param options
     * */
    public function run(configuration:Configuration, options:Array = null):void {
        var theRet:* = ARANEContext.context.call("runSession", configuration, options);
        if (theRet is ANEError) throw theRet as ANEError;
        _isRunning = true;
    }

    /** Pauses the session.
     *
     * <p>Once paused, no more updates will be received from the
     session until run is called again.</p>
     * */
    public function pause():void {
        if (_isRunning) {
            var theRet:* = ARANEContext.context.call("pauseSession");
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** Adds an anchor to the session. */
    public function add(anchor:Anchor):void {
        if (_isRunning) {
            var theRet:* = ARANEContext.context.call("addAnchor", anchor);
            if (theRet is ANEError) throw theRet as ANEError;
            anchor.id = theRet as String;
        }
    }

    /** Removes an anchor to the session. */
    public function remove(anchorId:String):void {
        if (_isRunning) {
            var theRet:* = ARANEContext.context.call("removeAnchor", anchorId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** Sets the world origin of the session to be at the position and orientation
     * specified by the provided transform. iOS 11.3+
     *
     * @param relativeTransform The rotation, translation and scale from the current world origin
     * to the desired world origin.
     *
     * */
    public function setWorldOriginSession(relativeTransform:Matrix3D):void {
        if (_isRunning) {
            var theRet:* = ARANEContext.context.call("setWorldOriginSession", relativeTransform);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

}
}
