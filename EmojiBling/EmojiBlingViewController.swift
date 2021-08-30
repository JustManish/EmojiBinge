//
//  ViewController.swift
//  EmojiBling
//
//  Created by mac on 30/08/21.
//

import ARKit
import UIKit

class EmojiBlingViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
          fatalError("Face tracking is not supported on this device")
        }
        
        sceneView.delegate = self
        //self.checkPermissions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
            
      // 1
      let configuration = ARFaceTrackingConfiguration()
            
      // 2
      sceneView.session.run(configuration)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
            
      // 1
      sceneView.session.pause()
    }
    
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
          case .authorized:
            return
          case .denied:
            abort()
          case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
              if(!authorized){
                abort()
              }
            })
          case .restricted:
            abort()
          @unknown default:
            fatalError()
        }
    }


}

extension EmojiBlingViewController: ARSCNViewDelegate {
  // 2
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    
    // 3
    guard let device = sceneView.device else {
      return nil
    }
    
    // 4
    let faceGeometry = ARSCNFaceGeometry(device: device)
    
    // 5
    let node = SCNNode(geometry: faceGeometry)
    
    // 6
    node.geometry?.firstMaterial?.fillMode = .lines
    
    // 7
    return node
  }
    
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        
        // 2
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        // 3
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    
}
