import UIKit
import AVFoundation

final class VideoPlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    private var player: AVPlayer! {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }


    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        player = AVPlayer()
    }
    
    /**
     Added asset in player.
     
     - parameters:
     - item: player item
     */
    func bind(item: AVPlayerItem?) {
        pause()
        player.replaceCurrentItem(with: item)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
}
