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

import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class AR3DView {
    private var _isInited:Boolean = false;
    private var _session:Session = new Session();
    private var _debugOptions:Array = [];
    private var _autoenablesDefaultLighting:Boolean = false;
    private var _automaticallyUpdatesLighting:Boolean = true;
    private var _showsStatistics:Boolean = false;
    private var _antialiasingMode:uint = AntialiasingMode.none;
    private var _scene:Scene = new Scene();

    public function AR3DView() {
    }

    public function init(frame:Rectangle = null):void {
        var theRet:* = ARANEContext.context.call("initScene3D", frame, _debugOptions, _autoenablesDefaultLighting,
                _automaticallyUpdatesLighting, _showsStatistics, _antialiasingMode, _scene.lightingEnvironment);
        if (theRet is ANEError) throw theRet as ANEError;
        _isInited = true;
        _scene.init();
    }

    public function dispose():void {
        var theRet:* = ARANEContext.context.call("disposeScene3D");
        if (theRet is ANEError) throw theRet as ANEError;
        _isInited = false;
    }


    //TODO
//    public function node(anchor:Anchor):void {
//
//    }
//
//    //TODO
//    public function anchor(node:Node):void {
//
//    }

    public function get session():Session {
        return _session;
    }

    public function get debugOptions():Array {
        return _debugOptions;
    }

    public function set debugOptions(value:Array):void {
        _debugOptions = value;
        if (_isInited) {
            var theRet:* = ARANEContext.context.call("setDebugOptions", _debugOptions);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function get autoenablesDefaultLighting():Boolean {
        return _autoenablesDefaultLighting;
    }

    public function set autoenablesDefaultLighting(value:Boolean):void {
        _autoenablesDefaultLighting = value;
        setANEvalue("autoenablesDefaultLighting", value);
    }

    public function get automaticallyUpdatesLighting():Boolean {
        return _automaticallyUpdatesLighting;
    }

    public function set automaticallyUpdatesLighting(value:Boolean):void {
        _automaticallyUpdatesLighting = value;
        setANEvalue("automaticallyUpdatesLighting", value);
    }

    public function get showsStatistics():Boolean {
        return _showsStatistics;
    }

    public function set showsStatistics(value:Boolean):void {
        _showsStatistics = value;
        setANEvalue("showsStatistics", value);
    }

    /**
     * This method is omitted from the output. * * @private
     */
    private function setANEvalue(name:String, value:*):void {
        if (_isInited) {
            var theRet:* = ARANEContext.context.call("setScene3DProp", name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /**
     * This method is omitted from the output. * * @private
     */
    private function initCheck():void {
        if (!_isInited) {
            throw new Error("You need to init first");
        }
    }


    public function get antialiasingMode():uint {
        return _antialiasingMode;
    }

    public function set antialiasingMode(value:uint):void {
        _antialiasingMode = value;
        setANEvalue("antialiasingMode", value);
    }

//    public function get light():Light {
//        return _light;
//    }
//
//    public function set light(value:Light):void {
//        _light = value;
//        _light.nodeId = "root";
//        setANEvalue("light", value);
//    }
    public function get scene():Scene {
        return _scene;
    }

}
}
