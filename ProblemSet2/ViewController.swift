//
//  ViewController.swift
//  ProblemSet2
//
//  Created by Blanchard, Cai on 2/5/19.
//  Copyright © 2019 Blanchard, Cai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var LlamaL1: UIButton!
    @IBOutlet weak var LlamaR1: UIButton!
    @IBOutlet weak var LlamaL2: UIButton!
    @IBOutlet weak var LlamaR2: UIButton!
    @IBOutlet weak var LlamaL3: UIButton!
    @IBOutlet weak var LlamaR3: UIButton!
    
    @IBOutlet weak var DoggoL1: UIButton!
    @IBOutlet weak var DoggoL2: UIButton!
    @IBOutlet weak var DoggoL3: UIButton!
    @IBOutlet weak var DoggoR3: UIButton!
    @IBOutlet weak var DoggoR2: UIButton!
    @IBOutlet weak var DoggoR1: UIButton!
    
    @IBOutlet weak var CanoeLeft: UIImageView!
    @IBOutlet weak var CanoeRight: UIImageView!
    
    @IBOutlet weak var CrossButton: UIButton!
    
    @IBOutlet weak var WinMsg: UILabel!
    @IBOutlet weak var LoseMsg: UILabel!
    
    @IBOutlet weak var Reset: UIButton!
    @IBOutlet weak var CounterLabel: UILabel!
    
    var crossingCounter: Int = 0
    
    var selected: [UIButton] = []
    var left: [UIButton] = []
    var right: [UIButton] = []
    var pairs: [[UIButton]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LlamaR1.isHidden = true
        LlamaR2.isHidden = true
        LlamaR3.isHidden = true
        DoggoR1.isHidden = true
        DoggoR2.isHidden = true
        DoggoR3.isHidden = true
        CanoeRight.isHidden = true
        WinMsg.isHidden = true
        LoseMsg.isHidden = true
        Reset.isHidden = true
        
        left = [LlamaL1, LlamaL2, LlamaL3, DoggoL1, DoggoL2, DoggoL3]
        pairs = [[LlamaL1, LlamaR1], [LlamaL2, LlamaR2], [LlamaL3, LlamaR3], [DoggoL1, DoggoR1], [DoggoL2, DoggoR2], [DoggoL3, DoggoR3]]
    }
    
    @IBAction func cross(_ sender: UIButton) {
        if selected.count > 0 {
            crossingCounter += 1
            CounterLabel.text = "Crossings: \(crossingCounter)"
            
        
            if CanoeRight.isHidden {
                //switch to right
                CanoeRight.isHidden = false
                CanoeLeft.isHidden = true
                
                moveAnimals(newSide: &right, oldSide: &left)
                
                for animal in left {
                    animal.isEnabled = false
                }
                for animal in right {
                    animal.isEnabled = true
                    animal.isHidden = false
                }
                
                checkStatus(left)
                
                
            } else {
                // switch to left
                CanoeRight.isHidden = true
                CanoeLeft.isHidden = false

                moveAnimals(newSide: &left, oldSide: &right)
                
                for animal in left {
                    animal.isEnabled = true
                    animal.isHidden = false
                }
                for animal in right {
                    animal.isEnabled = false
                }
                
                checkStatus(right)
            }
            
        }
    }
    
    func moveAnimals(newSide: inout Array<UIButton>, oldSide: inout Array<UIButton>) {
        var newSelected: [UIButton] = []
        
        if selected.count > 0 {
            
            for selectedAnimal in selected {
                for pair in pairs {
                    if pair.contains(selectedAnimal) {
                        if pair[0] == selectedAnimal {
                            newSelected.append(pair[1])
                        } else {
                            newSelected.append(pair[0])
                        }
                    }
                }
            }
            
            while selected.count > 0 {
                // deselect buttons and remove from that side
                let animal: UIButton = selected.popLast()!
                animal.isHidden = true
                let i = oldSide.index(of: animal)!
                oldSide.remove(at: i)
                animal.backgroundColor = UIColor.init( red: 0.0, green: 0.0, blue:0.0, alpha: 0.0 )
            }
        }
        
        for button in newSelected {
            newSide.append(button)
        }
        
    }
    
    @IBAction func clickAnimal(_ sender: UIButton) {
        if selected.contains(sender) {
            // deselect button
            if selected.count > 0 {
                let button = selected.popLast()!
                if button != sender {
                    selected.popLast()
                    selected.append(button)
                }
            }
            sender.backgroundColor = UIColor.init( red: 0.0, green: 0.0, blue:0.0, alpha: 0.0 )
            
        } else if selected.count < 2 {
            // select button
            selected.append(sender)
            sender.backgroundColor = UIColor.init( red: 0.0, green: 0.5, blue:0.5, alpha: 1.0 )
        }
    }
    
    func checkStatus(_ currentSide: Array<UIButton>) {
        // check if the user won
        if left.count == 0  && right.count == 6 {
            // you won!
            WinMsg.isHidden = false
            Reset.isHidden = false
            CrossButton.isHidden = true
        }
        
        // check if the user lost
        let tally: Int = tallySide(currentSide)
        if tally < 0 {
            if currentSide.contains(DoggoL1) || currentSide.contains(DoggoL2) || currentSide.contains(DoggoL3) || currentSide.contains(DoggoR1) || currentSide.contains(DoggoR2) || currentSide.contains(DoggoR3) {
                // you lost :(
                LoseMsg.isHidden = false
                Reset.isHidden = false
                CrossButton.isHidden = true
            }
        }
        
    }
    
    // check how many dogs/llamas on each side
    func tallySide(_ side: Array<UIButton>) -> Int {
        
        var tally: Int = 0
        
        for animal in side {
            
            if animal == LlamaL1 || animal == LlamaL2 || animal == LlamaL3 || animal == LlamaR1 || animal == LlamaR2 || animal == LlamaR3 {
                tally -= 1
            } else {
                tally += 1
            }
        }
        
        return tally
        
    }
    
    @IBAction func reset(_ sender: UIButton) {
        
        LlamaR1.isHidden = true
        LlamaR2.isHidden = true
        LlamaR3.isHidden = true
        DoggoR1.isHidden = true
        DoggoR2.isHidden = true
        DoggoR3.isHidden = true
        CanoeRight.isHidden = true
        WinMsg.isHidden = true
        LoseMsg.isHidden = true
        Reset.isHidden = true
        CrossButton.isHidden = false
        CanoeLeft.isHidden = false
        
        left = [LlamaL1, LlamaL2, LlamaL3, DoggoL1, DoggoL2, DoggoL3]
        for animal in left {
            animal.isHidden = false
            animal.isEnabled = true
        }
        right = []
        
        while selected.count > 0 {
            selected.popLast()
        }
        
        crossingCounter = 0
        CounterLabel.text = "Crossings: \(crossingCounter)"
        
    }
    
    
}

