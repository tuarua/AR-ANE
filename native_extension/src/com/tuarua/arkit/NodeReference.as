package com.tuarua.arkit {
import com.tuarua.ARANEContext;
import com.tuarua.arkit.animation.Action;
import com.tuarua.fre.ANEError;

[RemoteClass(alias="com.tuarua.arane.NodeReference")]
public class NodeReference {
    protected var _name:String;
    protected var _parentName:String;
    protected var _isAdded:Boolean = false;

    public function NodeReference(name:String = null) {
        this._name = name ? name : ARANEContext.context.call("createGUID") as String;
    }

    public function get name():String {
        return _name;
    }

    public function get isAdded():Boolean {
        return _isAdded;
    }

    public function set isAdded(value:Boolean):void {
        _isAdded = value;
    }

    public function get parentName():String {
        return _parentName;
    }

    public function set parentName(value:String):void {
        // TODO check native if parentName is null??
        _parentName = value;
    }

    public function runAction(action:Action):void {
        var ret:* = ARANEContext.context.call("node_runAction", action.id, _name);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function removeAllActions():void {
        var ret:* = ARANEContext.context.call("node_removeAllActions", _name);
        if (ret is ANEError) throw ret as ANEError;
    }
}
}
