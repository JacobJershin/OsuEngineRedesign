import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

public class ProductionRule
{
    public let predecessor: Character
    public let successor: String

    public init(predecessor: Character, successor: String)
    {
        self.predecessor = predecessor
        self.successor = successor
    }

    public func isTerminal() -> Bool
    {
        return String(predecessor) == successor
    }
}

public class ProductionRules
{
    private typealias RulesDictionary = Dictionary<Character, ProductionRule>
    private let rulesDictionary: RulesDictionary

    public init(alphabet: Set<Character>, productionRules: [ProductionRule])
    {
        var rulesDictionary = RulesDictionary()        
        //Add all explicitly declared rules
        for productionRule in productionRules
        {
            //Ensure there are no duplicates
            precondition(rulesDictionary[productionRule.predecessor] == nil,
                         "Duplicate rules are not permitted: \(productionRule.predecessor) was previously defined")

            //Ensure predecessor is present in alphabet
            precondition(alphabet.contains(productionRule.predecessor),
                         "Predecessor must be present in alphabet: \(productionRule.predecessor)")

            rulesDictionary[productionRule.predecessor] = productionRule
        }
        //Add implicit (degenerate) rules
        let predecessors = Set(productionRules.map { $0.predecessor }) //Iterates through productionRules to get all of the predecessors and creats a set of them
        let implicitConstants = alphabet.subtracting(predecessors)     //Makes a set of the alphabet minus the predecessors defined in the previous line
        for implicitConstant in implicitConstants
        {
            rulesDictionary[implicitConstant] =
              ProductionRule(predecessor: implicitConstant, successor: String(implicitConstant))
        }

        self.rulesDictionary = rulesDictionary
    }
    public func terminals() -> Set<Character>
    {
        let terminalRules = rulesDictionary.values.filter { $0.isTerminal() } //Makes a set terminalRules out of rulesdictionary of all the terminal rules
        return Set(terminalRules.map { $0.predecessor } )                   //Makes a set of the predecessors of terminalRules
    }

    public func successor(predecessor: Character) -> String
    {
        guard let foundSuccessor = rulesDictionary[predecessor]?.successor else //only continues if predecessor exists in rulesDictionary
        {
            fatalError("Unable to find successor for predecessor \(predecessor)")
        }
        return foundSuccessor
    }
}


public class LSystem
{
    private let alphabet: Set<Character>
    private let axiom: String
    private let productionRules: ProductionRules

    init(alphabet: Set<Character>, axiom: String, productionRules: [ProductionRule])
    {
        self.alphabet = alphabet
        self.axiom = axiom
        self.productionRules = ProductionRules(alphabet: alphabet,
                                               productionRules: productionRules)        
    }

    func terminals() -> Set<Character>
    {
        return productionRules.terminals()
    }

    func nonTerminals() -> Set<Character>
    {
        return alphabet.subtracting(terminals())
    }

    func produce(generationCount: Int) -> String
    {
        return generationCount == 0 ?                            // ? is an alternative "if/else" method
          axiom :                                                //Base case if generationCount == 0, the colon indicates any other value of generationCount
          produce(generationCount: generationCount - 1)          //recursively calls produce for the previous generation
          .map { productionRules.successor(predecessor: $0) }    //iterates through the production rules and creates an array of the successors for each character
          .joined()                                              //Concatenates all the members of the array into one string
    }
}

// globalFilter
func main()
{
    var alphabet = Set<Character>()
    var axiom: String? = nil
    var productionRules = [ProductionRule]()
    var generationCount: Int? = nil

    var line: String? = nil
    repeat
    {
        line = readLine()
        if let text = line
        {
            if text.starts(with: "alphabet:")
            {
                //Process alphabet
                let alphabetString = String(text.split(separator: ":")[1])
                for i in 0 ..< alphabetString.count
                {
                    alphabet.insert(alphabetString[i])
                }
            } else if text.starts(with: "axiom:")
            {
                //Process axiom
                axiom = String(text.split(separator: ":")[1])
            } else if text.starts(with: "productionRule:")
            {
                //Proccess production rule
                let productionRule = text.split(separator: ":")[1]
                let components = productionRule.split(separator: " ")
                productionRules.append( ProductionRule(predecessor: components[0][0], successor: String(components[2])) )
            } else if text.starts(with: "generationCount:")
            {
                //Proccess generationCount
                generationCount = Int(text.split(separator: ":")[1])
            }
        }
    } while line != nil
    
    let lsystem = LSystem(alphabet: alphabet, axiom: axiom!, productionRules: productionRules)
    print(lsystem.produce(generationCount: generationCount!))
}
