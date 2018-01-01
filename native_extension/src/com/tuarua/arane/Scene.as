package com.tuarua.arane {
import com.tuarua.ARANEContext;
import com.tuarua.arane.materials.MaterialProperty;
import com.tuarua.fre.ANEError;

public class Scene {
    private var _isInited:Boolean = false;
    private var _lightingEnvironment:MaterialProperty = new MaterialProperty(null, "lightingEnvironment");
    private var _rootNode:Node = new Node();

    public function Scene() {
    }

    public function init():void {
        _isInited = true;
        _lightingEnvironment.nodeId = "rootScene";
    }

    /**
     * This method is omitted from the output. * * @private
     */
    private function initCheck():void {
        if (!_isInited) {
            throw new Error("You need to init first");
        }
    }

    public function get lightingEnvironment():MaterialProperty {
        return _lightingEnvironment;
    }

    public function get rootNode():Node {
        return _rootNode;
    }

}
}
