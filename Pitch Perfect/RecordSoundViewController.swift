//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Kelvin Lee on 3/25/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool) {
        
        recordButton.enabled = true
        
        // hide stop button
        stopButton.hidden = true
        pauseRecordingButton.hidden = true
        
        recordingLabel.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        // disable the record button when already recording
        recordButton.enabled = false
        
        recordingLabel.text = "Recording..."
        
        // show the stop button when recording
        stopButton.hidden = false
        pauseRecordingButton.hidden = false

        
        // set the path and time then record the audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // timestamp the recording
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // set the file path for the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    
    @IBAction func pauseRecording(sender: UIButton) {
        
        // if it is recording, pause the recording
        if (audioRecorder.recording) {
            audioRecorder.pause()
            recordingLabel.text = "Recording paused"
            println("Recording paused")
        } else {
            // resume recording
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(true, error: nil)
            audioRecorder.record()
            recordingLabel.text = "Recording..."
            println("Recording resumed")
        }
    }
    
    // AVAudioRecorder delegate method
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag) {
            
            // record to this file path url
            recordedAudio = RecordedAudio(usingFilePathUrl: recorder.url, withTitle: recorder.url.lastPathComponent!)
        
            // segue to next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording") {
            
            let playSoundsViewController:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            
            playSoundsViewController.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        
        recordButton.enabled = true
        
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
        
        // stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

