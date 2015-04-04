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
    
    // helper function to stop audio
    func stopSounds() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // helper function to vary the audio speed rate
    func playAudioWithVariableRate(speed: Float) {
        
        stopSounds()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // helper function to play audio with a effect
    func playAudioWithVariableEffect(effect: AVAudioUnit) {
        
        stopSounds()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        // connect all the nodes
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        // start and play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        // set and attach the pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playAudioWithVariableEffect(changePitchEffect)
        
    }
    
        
    @IBAction func slowPlaybackButton(sender: UIButton) {
        
        playAudioWithVariableRate(0.5)
    }

    @IBAction func fastPlaybackButton(sender: UIButton) {
        
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        let echoEffect = AVAudioUnitDistortion()
        echoEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho1)
        
        playAudioWithVariableEffect(echoEffect)
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        
        // reverb setting
        reverbEffect.wetDryMix = 50
        
        playAudioWithVariableEffect(reverbEffect)
        
    }
    
    @IBAction func stopPlaybackButton(sender: UIButton) {
        
        // stop and reset the engine
        stopSounds()
        
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
