import AVFoundation
import UIKit

class CameraManager {
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!

    func setupCamera(previewView: UIView, delegate: AVCaptureVideoDataOutputSampleBufferDelegate, desiredFrameRate: Int) -> AVCaptureVideoPreviewLayer? {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Error: No video devices available")
            return nil
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: device)
            captureSession.beginConfiguration()
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            } else {
                print("Error: Cannot add device input to session")
                return nil
            }
            
            videoOutput = AVCaptureVideoDataOutput()
            let queue = DispatchQueue(label: "VideoQueue")
            videoOutput.setSampleBufferDelegate(delegate, queue: queue)
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            } else {
                print("Error: Cannot add video output to session")
                return nil
            }
            
            if let videoConnection = videoOutput.connection(with: .video) {
                if videoConnection.isVideoOrientationSupported {
                    videoConnection.videoOrientation = .portrait
                }
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            
            captureSession.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
            
            try device.lockForConfiguration()
            device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: Int32(desiredFrameRate))
            device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: Int32(desiredFrameRate))
            device.unlockForConfiguration()
            
            return previewLayer
        } catch {
            print("Error setting up camera: \(error)")
            return nil
        }
    }
    
    
    //カメラセッション停止用メソッド
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
                print("Camera session stopped.")
            }
        }
    }
    
    
    // カメラセッション再開用メソッド
    func resumeSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
                print("Camera session resumed.")
            }
        }
    }
    
}
