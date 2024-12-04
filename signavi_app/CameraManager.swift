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
            captureSession.addInput(deviceInput)
            
            videoOutput = AVCaptureVideoDataOutput()
            let queue = DispatchQueue(label: "VideoQueue")
            videoOutput.setSampleBufferDelegate(delegate, queue: queue)
            captureSession.addOutput(videoOutput)
            
            if let videoConnection = videoOutput.connection(with: .video) {
                if videoConnection.isVideoOrientationSupported {
                    videoConnection.videoOrientation = .portrait
                }
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            
            captureSession.commitConfiguration()
            captureSession.startRunning()
            
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
}
