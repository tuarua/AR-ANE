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

#import "FreMacros.h"
#import "ARANE_LIB.h"
#import <ARANE_FW/ARANE_FW.h>

#define FRE_OBJC_BRIDGE TRAKA_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation ARANE_LIB
SWIFT_DECL(TRAKA) // use unique prefix throughout to prevent clashes with other ANEs

CONTEXT_INIT(TRAKA) {
    SWIFT_INITS(TRAKA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRAKA, init)
        ,MAP_FUNCTION(TRAKA, createGUID)
        ,MAP_FUNCTION(TRAKA, getIosVersion)
        ,MAP_FUNCTION(TRAKA, appendToLog)
        ,MAP_FUNCTION(TRAKA, displayLogging)
        
        ,MAP_FUNCTION(TRAKA, ar3dview_init)
        ,MAP_FUNCTION(TRAKA, ar3dview_dispose)
        ,MAP_FUNCTION(TRAKA, ar3dview_debugOptions)
        ,MAP_FUNCTION(TRAKA, ar3dview_setProp)
        ,MAP_FUNCTION(TRAKA, ar3dview_node)
        ,MAP_FUNCTION(TRAKA, ar3dview_isNodeInsidePointOfView)
        ,MAP_FUNCTION(TRAKA, ar3dview_hitTest3D)
        ,MAP_FUNCTION(TRAKA, ar3dview_hitTest)
        ,MAP_FUNCTION(TRAKA, ar3dview_raycastQuery)
        ,MAP_FUNCTION(TRAKA, camera_position)
        
        ,MAP_FUNCTION(TRAKA, session_run)
        ,MAP_FUNCTION(TRAKA, session_pause)
        ,MAP_FUNCTION(TRAKA, session_setWorldOrigin)
        ,MAP_FUNCTION(TRAKA, session_saveCurrentWorldMap)
        ,MAP_FUNCTION(TRAKA, session_createReferenceObject)
        ,MAP_FUNCTION(TRAKA, session_add)
        ,MAP_FUNCTION(TRAKA, session_remove)
        ,MAP_FUNCTION(TRAKA, session_identifier)
        ,MAP_FUNCTION(TRAKA, session_raycast)
        ,MAP_FUNCTION(TRAKA, session_trackedRaycast)
        ,MAP_FUNCTION(TRAKA, session_lastTrackedRaycast)
        ,MAP_FUNCTION(TRAKA, raycast_stopTracking)
        
        ,MAP_FUNCTION(TRAKA, coaching_create)
        ,MAP_FUNCTION(TRAKA, coaching_activatesAutomatically)
        ,MAP_FUNCTION(TRAKA, coaching_setActive)
        
        ,MAP_FUNCTION(TRAKA, addModel)
        ,MAP_FUNCTION(TRAKA, supportsUserFaceTracking)
        
        ,MAP_FUNCTION(TRAKA, geometry_setProp)
        ,MAP_FUNCTION(TRAKA, material_setProp)
        ,MAP_FUNCTION(TRAKA, materialProperty_setProp)
        ,MAP_FUNCTION(TRAKA, light_setProp)
        
        ,MAP_FUNCTION(TRAKA, transaction_begin)
        ,MAP_FUNCTION(TRAKA, transaction_commit)
        ,MAP_FUNCTION(TRAKA, transaction_setProp)
        
        ,MAP_FUNCTION(TRAKA, action_create)
        ,MAP_FUNCTION(TRAKA, action_perform)
        ,MAP_FUNCTION(TRAKA, action_setProp)
        
        ,MAP_FUNCTION(TRAKA, node_runAction)
        ,MAP_FUNCTION(TRAKA, node_removeAllActions)
        ,MAP_FUNCTION(TRAKA, node_removeChildren)
        ,MAP_FUNCTION(TRAKA, node_removeFromParentNode)
        ,MAP_FUNCTION(TRAKA, node_addChildNode)
        ,MAP_FUNCTION(TRAKA, node_childNode)
        ,MAP_FUNCTION(TRAKA, node_setProp)
        
        ,MAP_FUNCTION(TRAKA, physics_applyForce)
        ,MAP_FUNCTION(TRAKA, physics_applyTorque)
        ,MAP_FUNCTION(TRAKA, physics_clearAllForces)
        ,MAP_FUNCTION(TRAKA, physics_resetTransform)
        ,MAP_FUNCTION(TRAKA, physics_setResting)
        ,MAP_FUNCTION(TRAKA, physicsWorld_addBehaviour)
        
        ,MAP_FUNCTION(TRAKA, vehicle_create)
        ,MAP_FUNCTION(TRAKA, vehicle_speedInKilometersPerHour)
        ,MAP_FUNCTION(TRAKA, vehicle_applyEngineForce)
        ,MAP_FUNCTION(TRAKA, vehicle_setSteeringAngle)
        ,MAP_FUNCTION(TRAKA, vehicle_applyBrakingForce)
        
        ,MAP_FUNCTION(TRAKA, planeAnchor_isClassificationSupported)
    
        ,MAP_FUNCTION(TRAKA, addEventListener)
        ,MAP_FUNCTION(TRAKA, removeEventListener)
        ,MAP_FUNCTION(TRAKA, requestPermissions)
        
        ,MAP_FUNCTION(TRAKA, showFocusSquare)
        ,MAP_FUNCTION(TRAKA, hideFocusSquare)
        ,MAP_FUNCTION(TRAKA, enableFocusSquare)
        ,MAP_FUNCTION(TRAKA, getFocusSquarePosition)
        
    };
    

    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRAKA) {
    [TRAKA_swft dispose];
    TRAKA_swft = nil;
    TRAKA_freBridge = nil;
    TRAKA_swftBridge = nil;
    TRAKA_funcArray = nil;
}
EXTENSION_INIT(TRAKA)
EXTENSION_FIN(TRAKA)
@end
