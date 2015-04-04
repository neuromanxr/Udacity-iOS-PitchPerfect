//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kelvin Lee on 3/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var error:NSError?
        
        // set the path for the audio file
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: &error)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // attach player node to audio engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // set and attach the pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect all the nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // start and play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    func playAudioWithEcho(preset: AVAudioUnitDistortionPreset) {
        
        // stop and reset the engine before playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // load the echo preset
        var audioPlayerNode = AVAudioPlayerNode()
        let echoEffect = AVAudioUnitDistortion()
        let echoPreset = preset
        echoEffect.loadFactoryPreset(echoPreset)
        
        // attach the nodes before connecting
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(echoEffect)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(preset: AVAudioUnitReverbPreset) {
        
        // stop and reset the engine before playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // load the reverb preset
        var audioPlayerNode = AVAudioPlayerNode()
        let reverbEffect = AVAudioUnitReverb()
        let reverbPreset = preset
        reverbEffect.loadFactoryPreset(reverbPreset)
        
        // reverb setting
        reverbEffect.wetDryMix = 50
        
        // attach the nodes before connecting
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(reverbEffect)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
        
    @IBAction func slowPlaybackButton(sender: UIButton) {
        
        // stop and reset the engine before playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func fastPlaybackButton(sender: UIButton) {
        
        // stop and reset the engine before playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        // use the AVAudioUnitDistortion presets
        playAudioWithEcho(AVAudioUnitDistortionPreset.MultiEcho1)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        playAudioWithReverb(AVAudioUnitReverbPreset.Cathedral)
    }
    
    @IBAction func stopPlaybackButton(sender: UIButton) {
        
        // stop and reset the engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        println("Playback stopped")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
