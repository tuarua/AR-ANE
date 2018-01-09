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

package com.tuarua.arane {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

internal class Session {
    private var _configuration:WorldTrackingConfiguration = new WorldTrackingConfiguration();

    public function Session() {
    }

    //noinspection JSMethodCanBeStatic
    public function run(configuration:Configuration, options:Array = null):void {
        var theRet:* = ARANEContext.context.call("runSession", configuration, options);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    //noinspection JSMethodCanBeStatic
    public function pause():void {
        var theRet:* = ARANEContext.context.call("pauseSession");
        if (theRet is ANEError) throw theRet as ANEError;
    }

    //noinspection JSMethodCanBeStatic
    public function add(anchor:Anchor):void {
        var theRet:* = ARANEContext.context.call("addAnchor", anchor);
        if (theRet is ANEError) throw theRet as ANEError;
        anchor.id = theRet as String;
    }

    //noinspection JSMethodCanBeStatic
    public function remove(anchorId:String):void {
        var theRet:* = ARANEContext.context.call("removeAnchor", anchorId);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get configuration():WorldTrackingConfiguration {
        return _configuration;
    }

    public function set configuration(value:WorldTrackingConfiguration):void {
        _configuration = value;
    }
}
}
