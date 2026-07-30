import Flutter
import UIKit
import AVKit

class PiPBridge: NSObject, AVPictureInPictureControllerDelegate {
    private var pipController: AVPictureInPictureController?
    private var pipPlayer: AVPlayer?
    private var pipPlayerLayer: AVPlayerLayer?
    private var channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "com.example.nolelamphim/pip",
            binaryMessenger: messenger
        )
        super.init()
        channel.setMethodCallHandler(handle)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isAvailable":
            if #available(iOS 14.0, *) {
                result(AVPictureInPictureController.isPictureInPictureSupported())
            } else {
                result(false)
            }
        case "enterPiP":
            if #available(iOS 14.0, *),
               AVPictureInPictureController.isPictureInPictureSupported() {
                guard let args = call.arguments as? [String: Any],
                      let urlString = args["url"] as? String,
                      let url = URL(string: urlString) else {
                    result(false)
                    return
                }
                let startSeconds = args["startSeconds"] as? Double ?? 0
                enterPiP(url: url, startSeconds: startSeconds)
                result(true)
            } else {
                result(false)
            }
        case "exitPiP":
            pipController?.stopPictureInPicture()
            result(nil)
        case "isInPiP":
            result(pipController?.isPictureInPictureActive ?? false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @available(iOS 14.0, *)
    private func enterPiP(url: URL, startSeconds: Double) {
        let playerItem = AVPlayerItem(url: url)
        pipPlayer = AVPlayer(playerItem: playerItem)
        guard let player = pipPlayer else { return }

        pipPlayerLayer?.removeFromSuperlayer()
        pipPlayerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = pipPlayerLayer else { return }
        playerLayer.frame = .zero
        playerLayer.videoGravity = .resizeAspect

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {}

        pipController?.delegate = nil
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
        pipController?.requiresLinearPlayback = false

        let seekTime = CMTime(seconds: startSeconds, preferredTimescale: 600)
        player.seek(to: seekTime) { _ in
            player.play()
            self.pipController?.startPictureInPicture()
        }
    }

    func pictureInPictureControllerDidStopPictureInPicture(
        _ controller: AVPictureInPictureController
    ) {
        pipPlayer?.pause()
        pipPlayer = nil
        pipPlayerLayer?.removeFromSuperlayer()
        pipPlayerLayer = nil
        pipController = nil
        channel.invokeMethod("onPiPExit", arguments: nil)
    }

    func pictureInPictureController(
        _ controller: AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: Error
    ) {
        pipPlayer = nil
        pipPlayerLayer?.removeFromSuperlayer()
        pipPlayerLayer = nil
        pipController = nil
    }
}
