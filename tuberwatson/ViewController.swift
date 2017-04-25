//
//  ViewController.swift
//  tuberwatson
//
//  Created by Ryan Welch on 4/23/17.
//  Copyright © 2017 Ryan Welch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TextToSpeechV1
import AVFoundation
import ConversationV1
import SpeechToTextV1

class ViewController: UIViewController {
    
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    @IBOutlet weak var convoinput: UITextField!
    @IBOutlet weak var convolabel: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var ttsinput: UITextField!
    
    @IBOutlet weak var sttlabel: UILabel!
    
    @IBAction func login(_ sender: Any) {
        if self.emailfield.text == "" || self.passwordfield.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailfield.text!, password: self.passwordfield.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    
    @IBAction func signup(_ sender: Any) {
        if emailfield.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailfield.text!, password: passwordfield.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func texttospeech(_ sender: Any) {
        let username = "f148e062-09ca-4755-9aed-91d8b3784aa2"
        let password = "mAk8rUcTIdYG"
        let textToSpeech = TextToSpeech(username: username, password: password)
        
        let text = ttsinput.text
        let failure = { (error: Error) in print(error) }
        textToSpeech.synthesize(text!, failure: failure) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer.play()
        }
        
    }
    
    @IBAction func convobutton(_ sender: Any) {
        let username = "ef05381e-583a-4bd3-8d03-bedc03c828ef"
        let password = "4YKjqsDt4seZ"
        let version = "2017-04-25" // use today's date for the most recent version
        let conversation = Conversation(username: username, password: password, version: version)
        let workspaceID = "38696758-a3e9-4fce-bc01-6c77ad9eeafc"
        let failure = { (error: Error) in print(error) }
        var context: Context? // save context to continue conversation
        let text = convoinput.text
        let request = MessageRequest(text: text!, context: context)
        conversation.message(withWorkspace: workspaceID, request: request, failure: failure) {
            response in
            print(response.output.text)
//            self.convolabel.text = response.text
            context = response.context
        }
        
        
    }
    
    
    @IBAction func listenstt(_ sender: Any) {
        let username = "5ce972f3-0ef5-4815-aa1f-5ee63ee33f41"
        let password = "eQv004W06iIf"
        let speechToText = SpeechToText(username: username, password: password)
        
        
        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true
        let failure = { (error: Error) in print(error) }
        speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
            print(results.bestTranscript)
            if self.sttlabel.text == " "
            {
                self.sttlabel.text = (results.bestTranscript)
            }
            else
            {
                self.sttlabel.text == " "
            }
        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

