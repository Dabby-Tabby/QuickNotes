import SwiftUI
import AVFoundation

// Main view containing the recording and sharing functionality
struct ContentView: View {
    @State var tapStatus = "" // Tracks the status of recording (Started/Stopped)
    @State var isClicked = false // Tracks if the recording button has been clicked
    @State var isFadedOut = false // Controls the fading animation of the recording button
    @State var showText = true // Determines whether the "Tap to Record" text should be shown
    @StateObject private var audioRecorder = AudioRecorder() // Manages audio recording functionality
    @State private var showShareButton = false // Controls the visibility of the share button
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                // Display a message to the user initially
                if showText {
                    Text("Tap to Record")
                        .opacity(0.95)
                        .font(.headline)
                        .onAppear {
                            // Hide the text after 3 seconds with animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showText = false
                                }
                            }
                        }
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    // Recording button toggles recording state and shows/hides share button
                    Button(action: {
                        if audioRecorder.isRecording {
                            audioRecorder.stopRecording()
                            self.tapStatus = "Recording Stopped"
                            withAnimation {
                                showShareButton = true
                            }
                        } else {
                            audioRecorder.startRecording()
                            self.tapStatus = "Recording Started"
                            withAnimation {
                                showShareButton = false
                            }
                        }
                        self.isClicked = !self.isClicked
                    }) {
                        ZStack {
                            // Button icon changes based on recording state
                            Image(systemName: audioRecorder.isRecording ? "stop.circle" : "waveform.circle")
                                .foregroundColor(audioRecorder.isRecording ? .red : .green)
                                .font(.system(size: 140))
                                .opacity(isFadedOut ? 0.6 : 1.0)
                                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isFadedOut)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        // Start fading animation on button appearance
                        isFadedOut.toggle()
                    }
                    
                    // Conditionally display the share button with animation
                    if showShareButton {
                        ShareLink(item: audioRecorder.getRecordingURL(), preview: SharePreview("Share Recording")) {
                            ZStack(alignment: .bottomTrailing) {
                                Text("Share")
                                    .frame(width: 80, height: 35)
                                    .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.blue.opacity(0.8), lineWidth: 0)
                                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue)))
                                    .foregroundColor(.white)
                                    .offset(y: -10)
                                    .opacity(0.8)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showShareButton)
        }
    }
}

#Preview {
    ContentView()
}
