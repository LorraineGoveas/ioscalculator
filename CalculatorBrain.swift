
import Foundation
struct CalculatorBrain{
    //value we are working with. view will set accumulator
    var accumulator : Double?
    private var currentPendingBinaryOperation: PendingBinaryOperation?
     var decimalPressed = true

    //operation enums holds constants or operations
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation( (Double,Double) -> Double )
        case equals
        case clear
    }
    
    var operations:[String: Operation] = [
        "pi":Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "x" : Operation.binaryOperation({ return $0 * $1 }),
        "/" : Operation.binaryOperation( { return $0 / $1 }),
        "+" : Operation.binaryOperation(
            { return $0 + $1 }
        ),
        "-" : Operation.binaryOperation({ return $0 - $1 }),
        "sqrt" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "log" : Operation.unaryOperation(log),
        "1/x" : Operation.unaryOperation({return 1/$0}),
        "%" : Operation.binaryOperation({
            return $0.truncatingRemainder (dividingBy: $1)
        }),

        "e^x" : Operation.unaryOperation(exp),
        "x^2" : Operation.unaryOperation({
            return $0 * $0 }),
        "x^3" : Operation.unaryOperation({
            return $0 * $0 * $0 }),
        "x^y" : Operation.binaryOperation({
            return pow($0, $1 )}),
        "10^x" : Operation.unaryOperation({
            return pow(10, $0 )}),
        "=" : Operation.equals,
        "C" : Operation.clear,
        
    ]
    
    
    
   mutating func performOperation(_ mathematicalSymbol: String){
    // if theres is something found for key assign it to constant then assign to accumulator
    //get something out of operations dictionary of type Operation
    if let operation = operations[mathematicalSymbol]{
        
        //getting value out of enum
        switch operation{
        case .constant(let value):
             accumulator = value
            
        case .unaryOperation (let function):
            if let value = accumulator {
            accumulator = function(value)
            }
        case .binaryOperation(let function):
            if let firstOperand = accumulator {
                currentPendingBinaryOperation =
                    PendingBinaryOperation(firstOperand: firstOperand, function: function)
                      accumulator = nil
            }
            
        case .equals:
            performBinaryOperation()
        
        case .clear:
             accumulator = 0
             currentPendingBinaryOperation = nil

        }
    }
    
    
    }
   mutating func setOperand(_ operand: Double){
        accumulator = operand
    
    }
    var result: Double?{
        get{
            return accumulator
        }
    }
    mutating func performBinaryOperation(){
        if let operation  = currentPendingBinaryOperation, let secondOperand = accumulator{
            accumulator = operation.perform(secondOperand : secondOperand)
        }
    }
    
    private struct PendingBinaryOperation{
        let firstOperand: Double
        let function: (Double, Double) -> Double
        func perform(secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
    }
    
}
