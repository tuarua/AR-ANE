package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.shapes.Model;

import flash.geom.Vector3D;

public class DaeModelExample {
    private var arkit:ARANE;
    public function DaeModelExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run():void {
        arkit.view3D.debugOptions = [];
        arkit.view3D.autoenablesDefaultLighting = false;
        arkit.view3D.showsStatistics = true;
        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

        var model:Model = new Model("objects/cherub/cherub.dae", "cherub", true);
        var node:Node = model.rootNode;

        if (node == null) {
            trace("no cherub");
            return;
        }

        arkit.view3D.scene.rootNode.addChildNode(node);
        node.position = new Vector3D(0, 0, -1.0); //r g b in iOS world origin

    }

    public function dispose():void {
        arkit.view3D.dispose();
    }
}
}
