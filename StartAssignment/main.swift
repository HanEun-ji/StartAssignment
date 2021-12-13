import Foundation

// readline에 왜 백스페이스 들어가지..?

protocol InputManager {
    static func getContatct()->Contact?
    static func getMenuInput()->String?
    static func removeWhiteSpaces(_ input: String)->String
}

protocol ValidityChecker {
    static func isNameCorrect(name: String) -> String?
    static func isAgeCorrect(age: String) -> String?
    static func isNumberCorrect(number: String) -> String?
    static func isMenuNumberCorrect(menuNumber: String) -> String?
}

protocol MenuManager {
    var contacts: [Contact] {get set}
    func printMenu()
    func addContact()
    func printAllContacts()
    func searchContactWithName()
}

class Contact {
    let name: String
    let age: String
    let number: String
    init(name: String, age: String, number: String) {
        self.name = name
        self.age = age
        self.number = number
    }
}

class InputChecker: ValidityChecker {
//      static func getValidValue<T>(_ checkFunction: (T) -> T?, _ target: T)-> T {
//          if let result = checkFunction(target) {
//              return result
//          }
//      }
    // 이름이 getCorrectName이 되는 것이 맞지 않을까...
    static func isNameCorrect(name: String) -> String? {
        if name.contains(" ") {
            
        }
        return name
    }
    static func isAgeCorrect(age: String) -> String? {
        let intAge: Int = Int(age) ?? -1
        switch intAge{
        case 0...130:
            return age
        default:
            return nil
        }
    }
    static func isNumberCorrect(number: String) -> String? {
        let bars = number.filter { ($0) == "-" }.count
        if bars != 2 {
            return nil
        }
        return number
    }
    static func isMenuNumberCorrect(menuNumber: String) -> String? {
        switch menuNumber{
        case "1", "2", "3", "x":
            return menuNumber
        default:
            return nil
        }
    }
}

class ContactInputManager: InputManager {
    static func getContatct()->Contact? {
        var result: Contact? = nil
        print("연락처 정보를 입력해주세요 : ", terminator:"")
        let userInformation: String? = readLine()
        if let information: String = userInformation {
            let processedInformation: [String] = information.split(separator: "/").map({ (subString: Substring) -> String in
                return removeWhiteSpaces(String(subString))
            })
            let name = InputChecker.isNameCorrect(name: processedInformation[0])
            let age = InputChecker.isAgeCorrect(age: processedInformation[1])
            let number = InputChecker.isNumberCorrect(number: processedInformation[2])
            if name != nil && age != nil && number != nil {
                // *** swift-ic??
                result = Contact(name: name!, age: age!, number: number!)
            }
        } else {
            print("아무것도 입력되지 않았습니다. 입력 형식을 확인해주세요.")
            return nil
        }
        switch result {
        case .some:
            print("입력한 정보는 \(result!.age)세 \(result!.name)(\(result!.number))입니다.")
        default:
            print("입력한 정보가 잘못되었습니다. 입력 형식을 확인해주세요.") // *** description
        //using result-string to print result might be good idea..
        }
        return result
    }
    
    static func getMenuInput() -> String? {
        let userInput = readLine()
        return userInput ?? nil
    }
    
    static func removeWhiteSpaces(_ input: String) -> String {
        return input.replacingOccurrences(of:" ", with:"")
    }
}

class ContactMenuManager: MenuManager {
    var isEnd = false
    var contacts: [Contact] = []
    func printMenu() {
        print("1) 연락처 추가 2) 연락처 목록보기 3) 연락처 검색 x) 종료\n메뉴를 선택해주세요 : ", terminator:"")
        let userInput: String? = ContactInputManager.getMenuInput()
        if let userMenuInput = userInput  {
            let menuIndex = InputChecker.isMenuNumberCorrect(menuNumber: userMenuInput)
            switch menuIndex {
            case "1":
                addContact()
            case "2":
                printAllContacts()
            case "3":
                searchContactWithName()
            case "x":
                isEnd = true
            default:
                print("선택이 잘못되었습니다 확인 후 다시 입력해주세요")
            }
        }
    }
    func addContact() {
        if let contact: Contact = ContactInputManager.getContatct() {
            contacts.append(contact)
        }
        contacts = contacts.sorted(by: {$0.name < $1.name })
    }
    
    func printAllContacts() {
        if contacts.count == 0 {
            print("연락처가 없습니다.")
        }
        for contact:Contact in contacts {
            print("- \(contact.name) / \(contact.age) / \(contact.number)")
        }
    }
    func searchContactWithName() {
        print("연락처에서 찾을 이름을 입력해주세요 : ", terminator:"")
            // **** using guard might be good!
        let inputName = readLine()
        if let targetName = inputName {
            for contact:Contact in contacts {
                if contact.name == targetName {
                    print("- \(contact.name) / \(contact.age) / \(contact.number)")
                }
            }
        }
    }
}

var menuManger: ContactMenuManager = ContactMenuManager()
while true {
    menuManger.printMenu()
    if menuManger.isEnd {
        break
    }
}
