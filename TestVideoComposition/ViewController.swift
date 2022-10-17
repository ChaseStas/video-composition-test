import AVFoundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var videoLayerView: UIView!
    private let videoPlayer = VideoPlayerView()

    private var url: URL = Bundle.main.url(forResource: "clip_test", withExtension: "MP4")!

    private var useVideoComposition = true
    private var renderSize: CGSize = .init(width: 1080, height: 1920)

    override func viewDidLoad() {
        super.viewDidLoad()

        videoLayerView.addSubview(videoPlayer)

        setupPlayerWithComposition()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPlayer.frame = videoLayerView.bounds
    }

    @IBAction func didTapDontUseAVVideoComposition() {
        useVideoComposition = false
        setupPlayerWithComposition()
    }

    func setupPlayerWithComposition() {
        let composition = AVMutableComposition()
        guard let track = composition.addMutableTrack(withMediaType: .video,
                                                      preferredTrackID: kCMPersistentTrackID_Invalid) else {
            fatalError()
        }

        let asset = AVAsset(url: url)
        let assetDuration = asset.duration
        let assetTrack = asset.tracks(withMediaType: .video).first!

        composition.naturalSize = renderSize
        try! track.insertTimeRange(CMTimeRangeMake(start: .zero, duration: assetDuration),
                                   of: assetTrack,
                                   at: .zero)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: .zero,
                                                duration: assetDuration)
        instruction.backgroundColor = UIColor.red.cgColor


        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: assetTrack)
        layerInstruction.setTransform(assetTrack.preferredTransform, at: .zero)
        instruction.layerInstructions = [layerInstruction]

        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [instruction.copy() as! AVVideoCompositionInstruction]
        videoComposition.frameDuration = CMTime(value: 1, timescale: CMTimeScale(60))
        videoComposition.renderSize = renderSize

        let playerItem = AVPlayerItem(asset: composition)
        if useVideoComposition {
            playerItem.videoComposition = videoComposition
        }

        videoPlayer.bind(item: playerItem)
        videoPlayer.play()
    }

}

