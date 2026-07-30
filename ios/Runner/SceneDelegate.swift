import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private var pipBridge: PiPBridge?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      pipBridge = PiPBridge(messenger: flutterViewController.binaryMessenger)
    }
  }
}
