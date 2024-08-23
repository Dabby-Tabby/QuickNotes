import AVFoundation

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var hasRecording = false
    @Published var clickCount = 0  // Counter to track button clicks
    
    func startRecording() {
        let fileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.record()
            isRecording = true
            hasRecording = false
            clickCount += 1  // Increment counter when recording starts
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        hasRecording = true  // Set hasRecording to true when recording stops
    }
    
    func playRecording() {
        let fileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileName)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play recording: \(error.localizedDescription)")
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func getRecordingURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
