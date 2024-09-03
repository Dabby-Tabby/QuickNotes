import AVFoundation

// Manages audio recording and playback functionality
class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder? // Handles the recording session
    private var audioPlayer: AVAudioPlayer? // Handles playback of the recorded audio
    @Published var isRecording = false // Indicates if the recording is currently active
    @Published var isPlaying = false // Indicates if the audio is currently being played
    @Published var hasRecording = false // Indicates if there is a saved recording available
    @Published var clickCount = 0  // Tracks the number of times the recording button has been clicked
    @Published var stopClickCount = 0 // Tracks the number of times the stop button has been clicked
    
    // Starts recording audio and configures settings
    func startRecording() {
        let fileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // Format of the audio recording
            AVSampleRateKey: 12000, // Sample rate of the audio recording
            AVNumberOfChannelsKey: 1, // Number of audio channels (1 for mono)
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // Audio quality setting
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.record() // Start recording
            isRecording = true
            hasRecording = false
            clickCount += 1 // Increment counter when recording starts
        } catch {
            print("Failed to start recording: \(error.localizedDescription)") // Handle recording start errors
        }
    }
    
    // Stops the recording session
    func stopRecording() {
        audioRecorder?.stop() // Stop the recording session
        isRecording = false
        hasRecording = true // Update the flag to indicate a recording is available
        stopClickCount += 1 // Increment counter when recording stops
    }
    
    // Plays the most recent recording
    func playRecording() {
        let fileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileName)
            audioPlayer?.play() // Start playback
            isPlaying = true
        } catch {
            print("Failed to play recording: \(error.localizedDescription)") // Handle playback errors
        }
    }
    
    // Stops the playback of the recording
    func stopPlayback() {
        audioPlayer?.stop() // Stop playback
        isPlaying = false
    }
    
    // Provides the URL to the recorded audio file
    func getRecordingURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
    
    // Retrieves the directory for storing user documents
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
