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
import com.tuarua.arane.raycast.RaycastQuery;
import com.tuarua.arane.raycast.RaycastResult;
import com.tuarua.arane.raycast.TrackedRaycast;
import com.tuarua.fre.ANEError;

import flash.filesystem.File;

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
        var ret:* = ARANEContext.context.call("session_run", configuration, options);
        if (ret is ANEError) throw ret as ANEError;
        _isRunning = true;
    }

    /** Pauses the session.
     *
     * <p>Once paused, no more updates will be received from the
     session until run is called again.</p>
     * */
    public function pause():void {
        if (!_isRunning) return;
        var ret:* = ARANEContext.context.call("session_pause");
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Adds an anchor to the session. */
    public function add(anchor:Anchor):void {
        if (!_isRunning) return;
        var ret:* = ARANEContext.context.call("session_add", anchor);
        if (ret is ANEError) throw ret as ANEError;
        anchor.id = ret as String;
    }

    /** Removes an anchor to the session. */
    public function remove(anchorId:String):void {
        if (!_isRunning) return;
        var ret:* = ARANEContext.context.call("session_remove", anchorId);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Sets the world origin of the session to be at the position and orientation
     * specified by the provided transform. iOS 11.3+
     *
     * @param relativeTransform The rotation, translation and scale from the current world origin
     * to the desired world origin.
     *
     * */
    public function setWorldOriginSession(relativeTransform:Matrix3D):void {
        if (!_isRunning) return;
        var ret:* = ARANEContext.context.call("session_setWorldOrigin", relativeTransform);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Copies the current state of the world being tracked by the session.
     * <p> A world map is only provided when running an ARWorldTrackingConfiguration.</p>
     * @param file
     * @param completionHandler The completion handler to call when the get has completed. This handler is executed<br/>
     * on the session's delegate queue. The completion handler takes the following parameters:<br/>
     * worldMap - The current world map or nil if unavailable.<br/>
     * error - An error that indicates why the world map is unavailable, or null if a world map was provided.<br/>
     * iOS 12.0+
     */
    public function saveCurrentWorldMap(file:File, completionHandler:Function):void {
        if (!_isRunning) return;
        var ret:* = ARANEContext.context.call("session_saveCurrentWorldMap", file.nativePath,
                ARANEContext.createCallback(completionHandler));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Unique identifier of the running session.
     * <p>The identifier may change after calling runWithConfiguration.</p>
     * iOS 13.0+
     */
    public function get identifier():String {
        var ret:* = ARANEContext.context.call("session_identifier");
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /**
     * Perform a raycast.
     * @param query Raycast query used for raycasting.
     * @return List of raycast results, sorted from nearest to farthest (in distance from the camera).
     * The results could be empty if raycast fails.
     * iOS 13.0+
     */
    public function raycast(query:RaycastQuery):Vector.<RaycastResult> {
        var ret:* = ARANEContext.context.call("session_raycast", query);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Vector.<RaycastResult>;
    }

    /**
     * Perform a tracked raycast.
     * <p>The session performs continuous raycasting and calls the update handler with the updated results.
     * The TrackedRaycast object returned can be used to update the raycast with a new raycast query or stop raycasting.</p>
     * @param query Raycast query used for raycasting.
     * @param updateHandler update handler where updated list of results, sorted from nearest to farthest (in distance from
     * the camera) are delivered. updateHandler will be called on session's delegate queue.
     * @return Tracked raycast object used to update or stop raycasting. This could be null if the raycast fails or if the
     * configuration is not WorldTrackingConfiguration or its subclasses.
     * iOS 13.0+
     */
    public function trackedRaycast(query:RaycastQuery, updateHandler:Function):TrackedRaycast {
        var ret:* = ARANEContext.context.call("session_trackedRaycast", query,
                ARANEContext.createCallback(updateHandler));
        if (ret is ANEError) throw ret as ANEError;
        return ret as TrackedRaycast;
    }

    /**
     * Creates a new reference object from scanned features within the provided bounds.
     * <p>Reference objects can be stored and used to track 3D objects from previously scanned data.<br>
     * Creation requires that an ObjectScanningConfiguration is used so that sufficient features are scanned.</p>
     * @param transform The transformation matrix that defines the rotation and translation of the bounds in<br>
     * world coordinates. This will be used as the reference object's transform, defining its coordinate space.
     * @param center The center of the object's bounds in the transform's coordinate space. A zero vector will<br>
     * define the object's origin centered within its extent.
     * @param extent The extent of the object's bounds in the transform's coordinate space. This defines the bounds'<br>
     * size in each dimension.
     * @param completionHandler The completion handler to call when the creation has completed. This handler is executed<br>
     * on the session's delegate queue. The completion handler takes the following parameters:<br>
     * referenceObject - The reference object created or null if unavailable.<br>
     * error - An error that indicates why creation failed, or null if a reference object was provided.<br>
     * iOS 12.0+
     */
    internal function createReferenceObject(transform:Matrix3D, center:Vector3D, extent:Vector3D,
                                            completionHandler:Function):void { //TODO closure
        if (!_isRunning) return;
        var ret:* = ARANEContext.context.call("session_createReferenceObject", transform, center,
                extent, ARANEContext.createCallback(completionHandler));
        if (ret is ANEError) throw ret as ANEError;
    }

}
}
