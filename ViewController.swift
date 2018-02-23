
// when optional is nil and use force unwrap it crashes

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var UserisTyping = false
    var brain = CalculatorBrain()
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        //! guarantees that the titlelabel exists and the text exists
        
        let buttonText = sender.titleLabel!.text!
        
        
        if UserisTyping{
            if buttonText == "." && display.text!.contains("."){
                return
            }
            else {
            let currentText = display.text!
            display.text = currentText + buttonText
            }
        }
        else{
            if buttonText == "." {
                display.text = "0" + buttonText
            }
            else{
            display.text = buttonText
            }
            UserisTyping = true
        }
    }
    var displayValue: Double{
        get{
            //take text of display and convert it to double
            // force unwrap display which is an optional
            //force unwrap double
            return Double(display.text!)!
        }
        set{
            //assigning double to textfield by converting it to string
            //set text of display to accept a double
            display.text = String(newValue)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        //only enters this block if mathematical symbol is not nil
        
        UserisTyping = false
        brain.setOperand(displayValue)
        //view controller tells model if something has changed on the ui layer
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            display.text = mathematicalSymbol
        }
        //view controller displays changed model
        if let result = brain.result{
            displayValue = result
        }
    }
    
}

