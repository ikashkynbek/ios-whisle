//
//  ViewController.swift
//  ios-whisle
//
//  Created by ik on 06/01/2017.
//  Copyright © 2017 ik. All rights reserved.
//

import UIKit
import AudioKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
    
    //    @IBOutlet var frequencyLabel: UILabel!
    //    @IBOutlet var amplitudeLabel: UILabel!
    @IBOutlet var audioInputPlot: EZAudioPlot!
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    
    func setupPlot() {
        let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        
        //        plot.plotType = .rolling
        plot.plotType = .buffer
        plot.gain = 5
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.blue
        audioInputPlot.addSubview(plot)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        AudioKit.output = silence
        //        AudioKit.start()
        //        setupPlot()
        //        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateUI), userInfo: nil, repeats: true)
    }
    
    func updateUI() {
        if tracker.amplitude > 0.1 {
            print(tracker.frequency)
            //            frequencyLabel.text = String(format: "%0.1f", tracker.frequency)
            
        }
        //        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
    }
    
    @IBAction func playAudio() {
        player()
        
    }
    
    func player() {
        let RAMP_TIME = 12.00
        let TOP_TIME = 75.36
        
        let sampleRate:UInt32 = 44100
        let mes:String = "hjntdb982ilj6etj6e3l\0";
        let size:Int = Int((Double(mes.characters.count) * (Double(sampleRate) * (TOP_TIME + RAMP_TIME) / 1000))) + 1;
        let samples = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        
        let length:Int = Int(generate(samples, sampleRate, UInt32(size), mes))
        print("Samples size \(length)")
        
        let time:Double = Double(length)/Double(sampleRate)
        print("Time \(time)")
        
        let engine = AVAudioEngine()
        let player:AVAudioPlayerNode = AVAudioPlayerNode()
//        let mixer = engine.mainMixerNode
//        print(mixer.outputFormat(forBus: 0).commonFormat.rawValue)
        let format = AVAudioFormat.init(commonFormat: AVAudioCommonFormat.pcmFormatFloat32, sampleRate: 44100.0, channels: 1, interleaved: false)
        //        let buffer = AVAudioPCMBuffer(pcmFormat: player.outputFormat(forBus: 0),frameCapacity:AVAudioFrameCount(length))
        let buffer = AVAudioPCMBuffer(pcmFormat: format,frameCapacity:AVAudioFrameCount(length))
        buffer.frameLength = AVAudioFrameCount(length)
        
        for i in 0 ..< length {
            //            print("i = \(i) => val =\(Float(samples[i]))")
            buffer.floatChannelData?.pointee[i] = Float(samples[i])
            //            buffer.int16ChannelData?.pointee[i] = Int16(samples[i])
        }
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        try! session.setActive(true)

        engine.attach(player)
        
        engine.connect(player, to: engine.mainMixerNode, format: format)
        //        engine.connect(player,to:mixer,format:mixer.outputFormat(forBus: 0))
        
        engine.prepare()
        try! engine.start()
        
        player.play()
        player.scheduleBuffer(buffer, at:nil, options:.interrupts, completionHandler:{print("asdasdasdasdasdasd")})
        print("before")
        Thread.sleep(forTimeInterval: time);
        print("after")
    }
    
}

