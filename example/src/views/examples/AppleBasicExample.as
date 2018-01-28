package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.shapes.Model;

public class AppleBasicExample {
    private var arkit:ARANE;

    public function AppleBasicExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run():void {
        arkit.view3D.debugOptions = [];
        arkit.view3D.showsStatistics = true;
        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

        var model:Model = new Model("art.scnassets/ship.scn");
        var shipNode:Node = model.rootNode;
        if (!shipNode) return;
        arkit.view3D.scene.rootNode.addChildNode(shipNode);

    }

    public function dispose():void {
        arkit.view3D.dispose();
    }

}
}
