import AVFoundation

class AudioManager {
    var player: AVPlayer?
    var timer: Timer?
    var volumeDipTimer: Timer?
    var lastPlaybackRate: Float = 0
    var lastPlayedTime: CMTime?
    
    func loadAudio(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }
    
    func playAudio(for duration: TimeInterval) {
        guard let player = player else { return }
        
        player.play()
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(startLoweringVolume), userInfo: nil, repeats: false)
    }
    
    @objc func startLoweringVolume() {
        guard let player = player else { return }
        
        lastPlayedTime = player.currentTime()
        lastPlaybackRate = player.rate
        player.pause() // Optional: to remember the spot and rate before lowering volume
        
        volumeDipTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(lowerVolume), userInfo: nil, repeats: true)
    }
    
    @objc func lowerVolume() {
        guard let player = player else { return }
        
        if player.volume > 0 {
            player.volume -= 0.03 // Adjust this value as per the required rate of volume decrease
        } else {
            volumeDipTimer?.invalidate()
            player.pause()
            player.volume = 1.0 // Reset volume if you plan to use the player again
        }
    }
    
    func resumePlayback() {
        guard let player = player, let lastPlayedTime = lastPlayedTime else { return }
        
        player.seek(to: lastPlayedTime) { [weak self] _ in
            self?.player?.playImmediately(atRate: self?.lastPlaybackRate ?? 1.0)
        }
    }
}
