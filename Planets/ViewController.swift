//
//  ViewController.swift
//  Planets
//
//  Created by Boris Alexis Gonzalez Macias on 11/11/17.
//  Copyright © 2017 PantlessDev. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sun = SCNNode()
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        
        let earthMoon = SCNNode()
        earthMoon.geometry = SCNSphere(radius: 0.03)
        earthMoon.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Moon diffuse")
        earthMoon.position = SCNVector3(0,0,-0.3)
        
        let venusMoon = SCNNode()
        venusMoon.geometry = SCNSphere(radius: 0.01)
        venusMoon.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Moon diffuse")
        venusMoon.position = SCNVector3(0,0,-0.15)
        
        sun.geometry = SCNSphere(radius: 0.35)
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun diffuse")
        sun.position = SCNVector3(0,0,-1)
        
        earthParent.position = sun.position
        venusParent.position = sun.position
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth_day"), specular: #imageLiteral(resourceName: "Earth_specular"), emission: #imageLiteral(resourceName: "Earth Clouds"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(1.2,0,0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Venus diffuse"), specular: nil, emission: #imageLiteral(resourceName: "Venus emission"), normal: nil, position: SCNVector3(0.7,0,0))

        let sunAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let sunForever = SCNAction.repeatForever(sunAction)
        sun.runAction(sunForever)
        
        earthParent.runAction(createRotation(x: 0, y: 360, z: 0, duration: 14))
        venusParent.runAction(createRotation(x: 0, y: 360, z: 0, duration: 8))
        
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        
        earth.runAction(createRotation(x: 0, y: 360, z: 0, duration: 8))
        earth.addChildNode(earthMoon)
        
        venus.runAction(createRotation(x: 0, y: 360, z: 0, duration: 6))
        venus.addChildNode(venusMoon)
        
        earthMoon.runAction(createRotation(x: 0, y: 360, z: 0, duration: 4))
        venusMoon.runAction(createRotation(x: 0, y: 360, z: 0, duration: 4))
    }
    
    func createRotation(x: Int, y: Int, z: Int, duration: Double) -> SCNAction {
        return SCNAction.repeatForever(
            SCNAction.rotateBy(
                x: CGFloat(x.degreesToRadians),
                y: CGFloat(y.degreesToRadians),
                z: CGFloat(z.degreesToRadians),
                duration: duration
            )
        )
    }
    
    func planet( geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3 ) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}

