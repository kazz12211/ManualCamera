//
//  ViewController.swift
//  ManualCamera
//
//  Created by Kazuo Tsubaki on 2018/08/11.
//  Copyright © 2018年 Kazuo Tsubaki. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerControl: UISegmentedControl!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var flashControl: UISegmentedControl!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var focusControl: UISegmentedControl!
    @IBOutlet weak var focusSlider: UISlider!
    @IBOutlet weak var counterButton: UIButton!
    @IBOutlet weak var zoomLabel: UILabel!
    @IBOutlet weak var lensPositionLabel: UILabel!
    @IBOutlet weak var shutterSpeedButton: UIButton!
    @IBOutlet weak var isoButton: UIButton!
    @IBOutlet weak var exposureButton: UIButton!
    @IBOutlet weak var whiteBalanceButton: UIButton!
    @IBOutlet weak var shutterSpeedLabel: UILabel!
    @IBOutlet weak var isoLabel: UILabel!
    @IBOutlet weak var exposureLabel: UILabel!
    @IBOutlet weak var whiteBalanceLabel: UILabel!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var whiteBalanceStepper: UIStepper!
    @IBOutlet weak var whiteBalanceValueLabel: UILabel!
    @IBOutlet weak var exposureStepper: UIStepper!
    @IBOutlet weak var exposureSwitch: UISwitch!
    @IBOutlet weak var exposureValueLabel: UILabel!
    @IBOutlet weak var isoStepper: UIStepper!
    @IBOutlet weak var isoValueLabel: UILabel!
    @IBOutlet weak var shutterSpeedStepper: UIStepper!
    @IBOutlet weak var shutterSpeedValueLabel: UILabel!
    @IBOutlet weak var isoSwitch: UISwitch!
    @IBOutlet weak var shutterSpeedSwitch: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var timelapseButton: UIButton!
    @IBOutlet weak var timelapseView: UIView!
    @IBOutlet weak var timelapseCountLabel: UILabel!
    @IBOutlet weak var timelapseCountStepper: UIStepper!
    @IBOutlet weak var timelapseIntervalLabel: UILabel!
    @IBOutlet weak var timelapseIntervalStepper: UIStepper!

    
    private let timerButtonImageNames: [String] = ["timer_off", "timer_2s", "timer_5s", "timer_10s"]
    private let flashButtonImageNames: [String] = ["flash_off", "flash_on", "flash_auto"]
    private let focusButtonImageNames: [String] = ["af", "mf"]
    
    static let TOP_BAR_HEIGHT: CGFloat = 60
    static let CONTROL_GAP: CGFloat = 12
    static let SCREEN_MARGIN: CGFloat = 16
    
    var camera: ManualCamera!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var guideRulerLayer: CAShapeLayer!
    var focusLayer: CAShapeLayer!
    var authorized: Bool!
    var selfTimer: SelfTimer!

    private let timelapseCountValues: [Int] = [0, 5, 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 120, 150, 180, 200, 250, 300, 400, 500, 600, 700, 800, 900, 1000]
    private let timelapseIntervalValues: [TimeInterval] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 120, 150, 180, 240, 300, 360, 420, 480, 540, 600, 900, 1800, 3600]
    
    private func authorizeCameraUsage(_ completionHandler: @escaping((_ success: Bool) -> Void)) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            DispatchQueue.main.async {
                completionHandler(granted)
            }
        }
    }
    
    private func authorizePhotoLibraryUsage(_ completionHandler: @escaping((_ success: Bool) -> Void)) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                completionHandler(status == .authorized)
            }
        }
    }
    
    private func failAndExit(message: String) {
        let alert = UIAlertController(title: "Initialization Error!", message: message, preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(exitAction)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorized = (AVCaptureDevice.authorizationStatus(for: .video) == .authorized) && (PHPhotoLibrary.authorizationStatus() == .authorized)
        
        if !authorized {
            authorizeCameraUsage { (success) in
                if success {
                    self.authorizePhotoLibraryUsage({ (success) in
                        if success {
                            self.authorized = true
                        } else {
                            self.authorized = false
                            self.failAndExit(message: "Failed to authorize photo library usage.\nPlease quit application.")
                        }
                    })
                } else {
                    self.authorized = false
                    self.failAndExit(message: "Failed to authorize camera usage.\nPlease quit application.")
                }
            }
        } else {
            self.camera = ManualCamera()
            self.camera.setDelegate(self)
            selfTimer = SelfTimer()
            selfTimer.initWithDelegate(self)
            self.setupSubviews()
            self.setupPreviewLayer()
            self.doAutoFocus(at: CGPoint(x: 0.5, y: 0.5))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
        // Preview Layer
        if previewLayer != nil {
            layoutPreviewLayer()
            showGuideRuler()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if camera != nil { camera.start() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if camera != nil { camera.stop() }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if camera == nil || selfTimer.active {
            return
        }
        let seconds = selfTimerInterval()
        if seconds == 0 {
            shoot()
        } else {
            selfTimer.run(seconds)
        }
    }
    
    private func shoot() {
        let orientation = previewLayer.connection?.videoOrientation
        camera.takePhoto(orientation: orientation!)
    }
    
    @IBAction func cancelShot(_ sender: UIButton) {
        counterButton.setAttributedTitle(NSAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 48), NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        counterButton.isHidden = true
        selfTimer.cancel()
    }
    
    @IBAction func doFocus(_ gestureRecognizer: UITapGestureRecognizer) {
        hideSettingView()
        if camera.focusMode == .auto {
            let touchPoint = gestureRecognizer.location(ofTouch: 0, in: previewView)
            if touchPoint.x < 30 || touchPoint.x > (previewView.frame.size.width - 30) || touchPoint.y < 30 || touchPoint.y > (previewView.frame.size.height - 30) {
                return
            }
            let point = CGPoint(x: touchPoint.x / previewView.frame.size.width, y: touchPoint.y / previewView.frame.size.width)
            showFocus(at: touchPoint)
            doAutoFocus(at: point)
        }
    }
    
    @IBAction func doZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        let pinchZoomScale = gestureRecognizer.scale
        camera.zoom(pinchZoomScale, end: gestureRecognizer.state == .ended) { (zoomFactor) -> (Void) in
            self.zoomLabel.text = "x".appendingFormat("%.1f", Float(zoomFactor))
        }
    }
    
    private func doAutoFocus(at point: CGPoint) {
        camera.autoFocus(at: point)
    }
            
    private func flashMode() -> AVCaptureDevice.FlashMode {
        switch flashControl.selectedSegmentIndex {
        case 0:
            return AVCaptureDevice.FlashMode.off
        case 1:
            return AVCaptureDevice.FlashMode.on
        default:
            return AVCaptureDevice.FlashMode.auto
        }
    }
    
    private func selfTimerInterval() -> Int {
        switch timerControl.selectedSegmentIndex {
        case 0:
            return 0
        case 1:
            return 2
        case 2:
            return 5
        case 3:
            return 10
        default:
            return 0
        }
    }
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
    }
    
    
    private func layoutPreviewLayer() {
        previewLayer.frame = previewView.bounds

        if let conn = previewLayer.connection {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                conn.videoOrientation = .landscapeRight
                break
            case .landscapeRight:
                conn.videoOrientation = .landscapeLeft
                break
            case .portrait:
                conn.videoOrientation = .portrait
                break
            case .portraitUpsideDown:
                conn.videoOrientation = .portraitUpsideDown
                break
            default: break
            }
        }
    }
    
    private func setupSubviews() {
        timerControl.isHidden = true
        timerControl.layer.masksToBounds = true
        timerControl.layer.cornerRadius = 4
        timerButton.setImage(UIImage(named: timerButtonImageNames[timerControl.selectedSegmentIndex]), for: .normal)
        flashControl.isHidden = true
        flashControl.layer.masksToBounds = true
        flashControl.layer.cornerRadius = 4
        flashButton.setImage(UIImage(named: flashButtonImageNames[flashControl.selectedSegmentIndex]), for: .normal)
        focusControl.isHidden = true
        focusControl.layer.masksToBounds = true
        focusControl.layer.cornerRadius = 4
        focusSlider.isHidden = true
        focusButton.setImage(UIImage(named: focusButtonImageNames[camera.focusMode.rawValue]), for: .normal)
        
        counterButton.backgroundColor = UIColor.red
        counterButton.layer.masksToBounds = true
        counterButton.layer.cornerRadius = 40
        counterButton.layer.opacity = 1
        counterButton.isHidden = true

        zoomLabel.text = "x".appendingFormat("%.1f", camera.zoomFactor())
        
        settingView.backgroundColor = UIColor.black
        settingView.layer.masksToBounds = true
        settingView.layer.cornerRadius = 8
        settingView.layer.opacity = 1
        settingView.isHidden = true
        
        whiteBalanceStepper.minimumValue = 0
        whiteBalanceStepper.maximumValue = Double(CameraConstants.WhiteBalanceLabels.count - 1)
        whiteBalanceStepper.value = 0
        whiteBalanceStepper.stepValue = 1
        
        exposureStepper.minimumValue = Double(camera.minExposureTargetBias)
        exposureStepper.maximumValue = Double(camera.maxExposureTargetBias)
        exposureStepper.value = Double(camera.exposureTargetBias())
        exposureStepper.stepValue = 0.5
        
        isoStepper.minimumValue = 0
        isoStepper.maximumValue = Double(CameraConstants.IsoValues.count - 1)
        isoStepper.value = 0
        isoStepper.stepValue = 1
        
        shutterSpeedStepper.minimumValue = 0
        shutterSpeedStepper.maximumValue = Double(CameraConstants.ExposureDurationValues.count - 1)
        shutterSpeedStepper.value = 0
        shutterSpeedStepper.stepValue = 1
        
        timelapseView.backgroundColor = UIColor.black
        timelapseView.layer.masksToBounds = true
        timelapseView.layer.cornerRadius = 8
        timelapseView.layer.opacity = 1
        timelapseView.isHidden = true
        
        timelapseCountStepper.minimumValue = 0
        timelapseCountStepper.maximumValue = Double(timelapseCountValues.count - 1)
        timelapseCountStepper.value = 0
        timelapseCountStepper.stepValue = 1

        timelapseIntervalStepper.minimumValue = 0
        timelapseIntervalStepper.maximumValue = Double(timelapseIntervalValues.count - 1)
        timelapseIntervalStepper.value = 0
        timelapseIntervalStepper.stepValue = 1

        layoutSubviews()
        
        if previewLayer != nil {
            layoutPreviewLayer()
            showGuideRuler()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doFocus(_:)))
        tapGesture.delegate = self
        previewView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(doZoom(_:)))
        pinchGesture.delegate = self
        previewView.addGestureRecognizer(pinchGesture)

    }
    
    private func showGuideRuler() {
        if guideRulerLayer != nil {
            guideRulerLayer.removeFromSuperlayer()
            guideRulerLayer = nil
        }
        guideRulerLayer = CAShapeLayer()
        guideRulerLayer.frame = previewLayer.superlayer!.bounds
        previewLayer.superlayer!.insertSublayer(guideRulerLayer, above: previewLayer)
        let rect = previewLayer.frame
        let linePath = UIBezierPath()
        linePath.lineWidth = 1.0
        linePath.move(to: CGPoint(x: 0, y: rect.height / 2))
        linePath.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        linePath.move(to: CGPoint(x: rect.width / 2, y: 40))
        linePath.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - 48))
        guideRulerLayer.path = linePath.cgPath
        guideRulerLayer.strokeColor = UIColor.orange.cgColor
    }
    
    func showFocus(at point: CGPoint) {
        if focusLayer == nil {
            focusLayer = CAShapeLayer()
            focusLayer.frame = previewLayer.bounds
            focusLayer.strokeColor = UIColor.orange.cgColor
            
            let rectPath = UIBezierPath()
            rectPath.lineWidth = 1.0
            rectPath.move(to: CGPoint(x: point.x - 30, y: point.y - 30))
            rectPath.addLine(to: CGPoint(x: point.x + 30, y: point.y - 30))
            rectPath.move(to: CGPoint(x: point.x + 30, y: point.y - 30))
            rectPath.addLine(to: CGPoint(x: point.x + 30, y: point.y + 30))
            rectPath.move(to: CGPoint(x: point.x + 30, y: point.y + 30))
            rectPath.addLine(to: CGPoint(x: point.x - 30, y: point.y + 30))
            rectPath.move(to: CGPoint(x: point.x - 30, y: point.y + 30))
            rectPath.addLine(to: CGPoint(x: point.x - 30, y: point.y - 30))
            focusLayer.path = rectPath.cgPath
            
            let baseLayer = guideRulerLayer == nil ? previewLayer : guideRulerLayer
            baseLayer.superlayer!.insertSublayer(focusLayer, above: baseLayer)
        }
    }

    func hideFocus() {
        if focusLayer != nil {
            focusLayer.removeFromSuperlayer()
            focusLayer = nil
        }
    }
    
    @IBAction func showTimerControl(_ sender: UIButton) {
        flashControl.isHidden = true
        timelapseView.isHidden = true
        timerControl.isHidden = !timerControl.isHidden
    }
    
    @IBAction func timerChanged(_ sender: UISegmentedControl) {
        timerControl.isHidden = true
        timerButton.setImage(UIImage(named: timerButtonImageNames[timerControl.selectedSegmentIndex]), for: .normal)
    }
    
    @IBAction func showFlashControl(_ sender: UIButton) {
        timerControl.isHidden = true
        timelapseView.isHidden = true
        flashControl.isHidden = !flashControl.isHidden
   }
    
    @IBAction func flashChanged(_ sender: UISegmentedControl) {
        flashControl.isHidden = true
        camera.flashMode = flashMode()
        flashButton.setImage(UIImage(named: flashButtonImageNames[flashControl.selectedSegmentIndex]), for: .normal)
    }
    
    @IBAction func showTimelapseControl(_ sender: UIButton) {
        flashControl.isHidden = true
        timerControl.isHidden = true
        timelapseView.isHidden = !timelapseView.isHidden
        timelapseCountLabel.text = "".appendingFormat("COUNT: %d", timelapseCountValues[Int(timelapseCountStepper.value)])
        timelapseIntervalLabel.text = "".appendingFormat("INTERVAL: %.0fS", timelapseIntervalValues[Int(timelapseIntervalStepper.value)])
        timelapseIntervalStepper.isEnabled = timelapseCountStepper.value > 0
        timelapseIntervalStepper.tintColor = timelapseIntervalStepper.isEnabled ? UIColor.orange : UIColor.gray
        timelapseIntervalLabel.textColor = timelapseIntervalStepper.isEnabled ? UIColor.orange : UIColor.gray
  }
    
    @IBAction func showFocusControl(_ sender: UIButton) {
        focusControl.isHidden = !focusControl.isHidden
        focusSlider.isHidden = focusControl.isHidden
        focusSlider.isEnabled = camera.focusMode == .manual
        focusSlider.minimumTrackTintColor = focusSlider.isEnabled ? UIColor.orange : UIColor.gray
        focusSlider.maximumTrackTintColor = focusSlider.isEnabled ? UIColor.orange : UIColor.gray
        focusSlider.thumbTintColor = focusSlider.isEnabled ? UIColor.orange : UIColor.gray
        focusSlider.value = camera.lensPosition()
   }
    
    @IBAction func focusModeChanged(_ sender: UISegmentedControl) {
        camera.focusMode = CameraFocusMode(rawValue: focusControl.selectedSegmentIndex)!
        focusSlider.isEnabled = camera.focusMode == .manual
        focusSlider.minimumTrackTintColor = focusSlider.isEnabled ? UIColor.orange : UIColor.gray
        focusSlider.maximumTrackTintColor = focusSlider.isEnabled ? UIColor.orange : UIColor.gray
        focusSlider.thumbTintColor = focusSlider.isEnabled ? UIColor.orange : UIColor.gray
        focusSlider.value = camera.lensPosition()
        focusButton.setImage(UIImage(named: focusButtonImageNames[camera.focusMode.rawValue]), for: .normal)
        if camera.focusMode == .auto {
            doAutoFocus(at: CGPoint(x: 0.5, y: 0.5))
        }
    }
    
    @IBAction func lensPositionChanged(_ sender: UISlider) {
        camera.manualFocus(lensPosition: focusSlider.value) { () -> (Void) in
            self.lensPositionLabel.text = "".appendingFormat("%.2f", self.camera.lensPosition())
        }
    }
    
    private func showSettingView(mode: CameraSettingMode) {
        switch mode {
        case .exposure:
            layoutExposureControl()
        case .iso:
            layoutIsoControl()
        case .shutterSpeed:
            layoutShutterSpeedControl()
        case .whiteBalance:
            layoutWhiteBalanceControl()
        default:
            break
        }
        camera.settingMode = mode
        settingView.isHidden = false
    }
    
    private func hideSettingView() {
        camera.settingMode = .none
        settingView.isHidden = true
    }
    
    @IBAction func showWhiteBalanceControl(_ sender: UIButton) {
        if camera.settingMode == .whiteBalance {
            hideSettingView()
        } else {
            showSettingView(mode: .whiteBalance)
        }
    }
    
    @IBAction func showExposureControl(_ sender: UIButton) {
        if camera.settingMode == .exposure {
            hideSettingView()
        } else {
            showSettingView(mode: .exposure)
            exposureSwitch.isOn = camera.exposureMode == .manual
            exposureStepper.isEnabled = exposureSwitch.isOn
            exposureStepper.value = Double(camera.exposureTargetBias)
            exposureValueLabel.text = "".appendingFormat("%.1f", camera.exposureTargetBias)
            exposureValueLabel.textColor = exposureStepper.isEnabled ? UIColor.orange : UIColor.gray
            exposureStepper.tintColor = exposureStepper.isEnabled ? UIColor.orange : UIColor.gray
        }
    }
    
    @IBAction func showIsoControl(_ sender: UIButton) {
        if camera.settingMode == .iso {
            hideSettingView()
        } else {
            showSettingView(mode: .iso)
            isoSwitch.isOn = camera.isoMode == .manual
            isoStepper.isEnabled = isoSwitch.isOn
            isoStepper.value = Double(camera.indexOfISO())
            isoValueLabel.text = "".appendingFormat("%.0f", camera.iso())
            isoValueLabel.textColor = isoStepper.isEnabled ? UIColor.orange : UIColor.gray
            isoStepper.tintColor = isoStepper.isEnabled ? UIColor.orange : UIColor.gray
        }
    }
    
    @IBAction func showShutterSpeedControl(_ sender: UIButton) {
        if camera.settingMode == .shutterSpeed {
            hideSettingView()
        } else {
            showSettingView(mode: .shutterSpeed)
            shutterSpeedSwitch.isOn = camera.shutterMode == .manual
            shutterSpeedStepper.isEnabled = shutterSpeedSwitch.isOn
            shutterSpeedStepper.value = Double(camera.indexOfShutterSpeed())
            shutterSpeedValueLabel.text = camera.exposureDurationLabel()
            shutterSpeedValueLabel.textColor = shutterSpeedStepper.isEnabled ? UIColor.orange : UIColor.gray
            shutterSpeedStepper.tintColor = shutterSpeedStepper.isEnabled ? UIColor.orange : UIColor.gray
        }
    }
    
    @IBAction func changeWhiteBalance(_ sender: UIStepper) {
        let index = Int(sender.value)
        whiteBalanceValueLabel.text = CameraConstants.WhiteBalanceLabels[index]
        whiteBalanceLabel.text = CameraConstants.WhiteBalanceLabels[index]
        camera.selectedWhiteBalanceIndex = index
    }
    
    @IBAction func changeExposure(_ sender: UIStepper) {
        let value = Float(sender.value)
        exposureValueLabel.text = "".appendingFormat("%.1f", value)
        camera.exposureTargetBias = value
    }
    
    @IBAction func toggleExposure(_ sender: UISwitch) {
        if sender.isOn {
            camera.exposureMode = .manual
       } else {
            camera.exposureMode = .auto
        }
        exposureStepper.isEnabled = sender.isOn
        exposureValueLabel.text = "".appendingFormat("%.1f", camera.exposureTargetBias)
        exposureValueLabel.textColor = exposureStepper.isEnabled ? UIColor.orange : UIColor.gray
        exposureStepper.tintColor = exposureStepper.isEnabled ? UIColor.orange : UIColor.gray
    }
    
    @IBAction func changeISO(_ sender: UIStepper) {
        let index = Int(sender.value)
        camera.selectISO(index)
        isoValueLabel.text = "".appendingFormat("%.0f", camera.iso())
        isoLabel.text = "".appendingFormat("%.0f", camera.iso())
    }
    
    @IBAction func toggleISO(_ sender: UISwitch) {
        if sender.isOn {
            camera.isoMode = .manual
        } else {
            camera.isoMode = .auto
        }
        isoStepper.isEnabled = sender.isOn
        isoValueLabel.text = "".appendingFormat("%.0f", camera.iso())
        isoValueLabel.textColor = isoStepper.isEnabled ? UIColor.orange : UIColor.gray
        isoStepper.tintColor = isoStepper.isEnabled ? UIColor.orange : UIColor.gray
   }
    
    @IBAction func changeShutterSpeed(_ sender: UIStepper) {
        let index = Int(sender.value)
        camera.selectShutterSpeed(index)
        shutterSpeedValueLabel.text = camera.exposureDurationLabel()
        shutterSpeedLabel.text = camera.exposureDurationLabel()
    }
    
    @IBAction func toggleShutterSpeed(_ sender: UISwitch) {
        if sender.isOn {
            camera.shutterMode = .manual
        } else {
            camera.shutterMode = .auto
        }
        shutterSpeedStepper.isEnabled = sender.isOn
        shutterSpeedValueLabel.text = camera.exposureDurationLabel()
        shutterSpeedValueLabel.textColor = shutterSpeedStepper.isEnabled ? UIColor.orange : UIColor.gray
        shutterSpeedStepper.tintColor = shutterSpeedStepper.isEnabled ? UIColor.orange : UIColor.gray
    }
    
    @IBAction func changeTimelapseCount(_ sender: UIStepper) {
        timelapseCountLabel.text = "".appendingFormat("COUNT: %d", timelapseCountValues[Int(timelapseCountStepper.value)])
        timelapseIntervalStepper.isEnabled = timelapseCountStepper.value > 0
        timelapseIntervalStepper.tintColor = timelapseIntervalStepper.isEnabled ? UIColor.orange : UIColor.gray
        timelapseIntervalLabel.textColor = timelapseIntervalStepper.isEnabled ? UIColor.orange : UIColor.gray
    }
    
    @IBAction func changeTimelapseInterval(_ sender: UIStepper) {
        timelapseIntervalLabel.text = "".appendingFormat("INTERVAL: %.0fS", timelapseIntervalValues[Int(timelapseIntervalStepper.value)])
   }
}

extension ViewController: CameraDelegate {

    func cameraDidFinishFocusing(_ camera: Camera, device: AVCaptureDevice) {
        hideFocus()
        focusSlider.value = device.lensPosition
        lensPositionLabel.text = "".appendingFormat("%.2f", device.lensPosition)
    }
    
    func cameraDidFinishExposing(_ camera: Camera, device: AVCaptureDevice) {
        let c = camera as! ManualCamera
        if c.shutterMode == .auto {
            shutterSpeedLabel.text = c.exposureDurationLabel()
            shutterSpeedValueLabel.text = c.exposureDurationLabel()
        }
        if c.isoMode == .auto {
            isoLabel.text = "".appendingFormat("%.0f", c.iso())
            isoValueLabel.text = "".appendingFormat("%.0f", c.iso())
        }
        exposureLabel.text = "".appendingFormat("%.1f", device.exposureTargetBias)
        c.isoValue = c.iso()
        c.shutterSpeedValue = c.exposureDuration()
        
    }
    
    func cameraDidFinishWhiteBalancing(_ camera: Camera, device: AVCaptureDevice) {
        let wb = device.deviceWhiteBalanceGains
        print(wb)
    }
    
    func cameraDidFinishSettingExposureTargetBias(_ camera: Camera, device: AVCaptureDevice) {
        exposureLabel.text = "".appendingFormat("%.1f", device.exposureTargetBias)
        exposureValueLabel.text = "".appendingFormat("%.1f", device.exposureTargetBias)
    }
}

extension ViewController: SelfTimerDelegate {
    
    func selfTimerCountdown(_ timer: SelfTimer, counter: Int) {
        AudioServicesPlaySystemSound(SystemSoundID(1113))
        counterButton.setAttributedTitle(NSAttributedString(string: "\(counter)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 48), NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        counterButton.isHidden = false
    }
    
    func selfTimerFinished(_ timer: SelfTimer) {
        counterButton.isHidden = true
        shoot()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
