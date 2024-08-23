import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var tapStatus = ""
    @State var isClicked = false
    @State var isFadedOut = false
    @State var showText = true
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if showText {
                    Text("Tap to Record")
                        .font(.headline)
                        .onAppear {
                            // Hide the text after 3 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showText = false
                                }
                            }
                        }
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Button(action: {
                        if audioRecorder.isRecording {
                            audioRecorder.stopRecording()
                            self.tapStatus = "Recording Stopped"
                        } else {
                            audioRecorder.startRecording()
                            self.tapStatus = "Recording Started"
                        }
                        self.isClicked = !self.isClicked
                    }) {
                        ZStack {
                            Image(systemName: audioRecorder.isRecording ? "stop.circle" : "waveform.circle")
                                .foregroundColor(audioRecorder.isRecording ? .red : .green)
                                .font(.system(size: 140))
                                .opacity(isFadedOut ? 0.5 : 1.0)
                                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isFadedOut)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        isFadedOut.toggle()
                    }
                    
                    
                    // Share Button
                    if audioRecorder.clickCount > 0 {
                        ShareLink(item: audioRecorder.getRecordingURL(), preview: SharePreview("Share Recording")) {
                            ZStack(alignment: .bottomTrailing) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 30))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
