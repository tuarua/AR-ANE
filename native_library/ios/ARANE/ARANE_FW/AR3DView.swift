/*
 Copyright © 2017 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial
 portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import ARKit

class AR3DView: ARSCNView {

    // MARK: - Types

    struct HitTestRay {
        var origin: SIMD3<Float>
        var direction: SIMD3<Float>

        func intersectionWithHorizontalPlane(atY planeY: Float) -> SIMD3<Float>? {
            let normalizedDirection = simd_normalize(direction)

            // Special case handling: Check if the ray is horizontal as well.
            if normalizedDirection.y == 0 {
                if origin.y == planeY {
                    /*
                     The ray is horizontal and on the plane, thus all points on the ray
                     intersect with the plane. Therefore we simply return the ray origin.
                     */
                    return origin
                } else {
                    // The ray is parallel to the plane and never intersects.
                    return nil
                }
            }

            /*
             The distance from the ray's origin to the intersection point on the plane is:
             (`pointOnPlane` - `rayOrigin`) dot `planeNormal`
             --------------------------------------------
             direction dot planeNormal
             */

            // Since we know that horizontal planes have normal (0, 1, 0), we can simplify this to:
            let distance = (planeY - origin.y) / normalizedDirection.y

            // Do not return intersections behind the ray's origin.
            if distance < 0 {
                return nil
            }

            // Return the intersection point.
            return origin + (normalizedDirection * distance)
        }

    }

    struct FeatureHitTestResult {
        var position: SIMD3<Float>
        var distanceToRayOrigin: Float
        var featureHit: SIMD3<Float>
        var featureDistanceToHitResult: Float
    }

    // MARK: Position Testing
    
    /// Hit tests against the `sceneView` to find an object at the provided point.
//    func virtualObject(at point: CGPoint) -> VirtualObject? {
//        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
//        let hitTestResults = hitTest(point, options: hitTestOptions)
//        
//        return hitTestResults.lazy.flatMap { result in
//            return VirtualObject.existingObjectContainingNode(result.node)
//        }.first
//    }

    /**
     Hit tests from the provided screen position to return the most accuarte result possible.
     Returns the new world position, an anchor if one was hit, and if the hit test is considered to be on a plane.
     */
    func worldPosition(fromScreenPosition position: CGPoint,
                       objectPosition: SIMD3<Float>?,
                       infinitePlane: Bool = false) -> (position: SIMD3<Float>,
        planeAnchor: ARPlaneAnchor?, isOnPlane: Bool)? {
        /*
         1. Always do a hit test against exisiting plane anchors first. (If any
            such anchors exist & only within their extents.)
        */
        let planeHitTestResults = hitTest(position, types: .existingPlaneUsingExtent)
        
        if let result = planeHitTestResults.first {
            let planeHitTestPosition = result.worldTransform.translation
            let planeAnchor = result.anchor
            
            // Return immediately - this is the best possible outcome.
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        /*
         2. Collect more information about the environment by hit testing against
            the feature point cloud, but do not return the result yet.
        */
        let featureHitTestResult = hitTestWithFeatures(position,
                                                       coneOpeningAngleInDegrees: 18,
                                                       minDistance: 0.2,
                                                       maxDistance: 2.0).first
        let featurePosition = featureHitTestResult?.position

        /*
         3. If desired or necessary (no good feature hit test result): Hit test
            against an infinite, horizontal plane (ignoring the real world).
        */
        if infinitePlane || featurePosition == nil {
            if let objectPosition = objectPosition,
                let pointOnInfinitePlane = hitTestWithInfiniteHorizontalPlane(position, objectPosition) {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        
        /*
         4. If available, return the result of the hit test against high quality
            features if the hit tests against infinite planes were skipped or no
            infinite plane was hit.
        */
        if let featurePosition = featurePosition {
            return (featurePosition, nil, false)
        }
        
        /*
         5. As a last resort, perform a second, unfiltered hit test against features.
            If there are no features in the scene, the result returned here will be nil.
        */
        let unfilteredFeatureHitTestResults = hitTestWithFeatures(position)
        if let result = unfilteredFeatureHitTestResults.first {
            return (result.position, nil, false)
        }
        
        return nil
    }

    // MARK: - Hit Tests

    func hitTestRayFromScreenPosition(_ point: CGPoint) -> HitTestRay? {
        guard let frame = session.currentFrame else { return nil }

        let cameraPos = frame.camera.transform.translation

        // Note: z: 1.0 will unproject() the screen position to the far clipping plane.
        let positionVec = SIMD3<Float>(x: Float(point.x), y: Float(point.y), z: 1.0)
        let screenPosOnFarClippingPlane = unprojectPoint(positionVec)

        let rayDirection = simd_normalize(screenPosOnFarClippingPlane - cameraPos)
        return HitTestRay(origin: cameraPos, direction: rayDirection)
    }

    func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: SIMD3<Float>) -> SIMD3<Float>? {
        guard let ray = hitTestRayFromScreenPosition(point) else { return nil }

        // Do not intersect with planes above the camera or if the ray is almost parallel to the plane.
        if ray.direction.y > -0.03 {
            return nil
        }

        /*
         Return the intersection of a ray from the camera through the screen position
         with a horizontal plane at height (Y axis).
         */
        return ray.intersectionWithHorizontalPlane(atY: pointOnPlane.y)
    }

    func hitTestWithFeatures(_ point: CGPoint, coneOpeningAngleInDegrees: Float,
                             minDistance: Float = 0,
                             maxDistance: Float = Float.greatestFiniteMagnitude,
                             maxResults: Int = 1) -> [FeatureHitTestResult] {

        guard let features = session.currentFrame?.rawFeaturePoints,
            let ray = hitTestRayFromScreenPosition(point) else {
            return []
        }

        let maxAngleInDegrees = min(coneOpeningAngleInDegrees, 360) / 2
        let maxAngle = (maxAngleInDegrees / 180) * .pi

        let results = features.points.compactMap { featurePosition -> FeatureHitTestResult? in
            let originToFeature = featurePosition - ray.origin

            let crossProduct = simd_cross(originToFeature, ray.direction)
            let featureDistanceFromResult = simd_length(crossProduct)

            let hitTestResult = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
            let hitTestResultDistance = simd_length(hitTestResult - ray.origin)

            if hitTestResultDistance < minDistance || hitTestResultDistance > maxDistance {
                // Skip this feature - it is too close or too far away.
                return nil
            }

            let originToFeatureNormalized = simd_normalize(originToFeature)
            let angleBetweenRayAndFeature = acos(simd_dot(ray.direction, originToFeatureNormalized))

            if angleBetweenRayAndFeature > maxAngle {
                // Skip this feature - is is outside of the hit test cone.
                return nil
            }

            // All tests passed: Add the hit against this feature to the results.
            return FeatureHitTestResult(position: hitTestResult,
                                        distanceToRayOrigin: hitTestResultDistance,
                                        featureHit: featurePosition,
                                        featureDistanceToHitResult: featureDistanceFromResult)
        }

        // Sort the results by feature distance to the ray origin.
        let sortedResults = results.sorted { $0.distanceToRayOrigin < $1.distanceToRayOrigin }

		let remainingResults = maxResults > 0 ? Array(sortedResults.prefix(maxResults)) : sortedResults

        return Array(remainingResults)
    }

    func hitTestWithFeatures(_ point: CGPoint) -> [FeatureHitTestResult] {
        guard let features = session.currentFrame?.rawFeaturePoints,
            let ray = hitTestRayFromScreenPosition(point) else {
                return []
        }

        /*
         Find the feature point closest to the hit test ray, then create
         a hit test result by finding the point on the ray closest to that feature.
         */
        let possibleResults = features.points.map { featurePosition in
            return FeatureHitTestResult(featurePoint: featurePosition, ray: ray)
        }
        let closestResult = possibleResults.min(by: { $0.featureDistanceToHitResult < $1.featureDistanceToHitResult })!
        return [closestResult]
    }

}

extension SCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD float3 type is helpful.
     */
    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
}

extension AR3DView.FeatureHitTestResult {
    /// Add a convenience initializer to `FeatureHitTestResult` for `HitTestRay`.
    /// By adding the initializer in an extension, we also get the default initializer for `FeatureHitTestResult`.
    init(featurePoint: SIMD3<Float>, ray: AR3DView.HitTestRay) {
        self.featureHit = featurePoint
        
        let originToFeature = featurePoint - ray.origin
        self.position = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
        self.distanceToRayOrigin = simd_length(self.position - ray.origin)
        self.featureDistanceToHitResult = simd_length(simd_cross(originToFeature, ray.direction))
    }
}
