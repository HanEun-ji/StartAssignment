import Foundation

protocol InputManagable {
    func toContact(from: String) -> Contact?
}

protocol MenuManagable {
    func printMenu() -> Bool
    func addContact()
    func printAll(contacts: [Contact])
    func searchContactWithName()
}

struct Contact {
    var name: String?
    var age: UInt?
    var telNumber: String?
    
    enum Validity {
        case valid(Contact), noName, noAge, noTelNumber
        var output: String {
            switch self {
            case .valid(let contact):
                guard let name = contact.name, let age = contact.age, let telNumber = contact.telNumber else { return "" }
                return "입력한 정보는 \(age)세 \(name)(\(telNumber))입니다."
            case .noName:
                return "입력한 이름 정보가 잘못되었습니다. 입력 형식을 확인해주세요."
            case .noAge:
                return "입력한 나이 정보가 잘못되었습니다. 입력 형식을 확인해주세요."
            case .noTelNumber:
                return "입력한 전화번호 정보가 잘못되었습니다. 입력 형식을 확인해주세요."
            }
        }
    }
    
    init(name: String, age: String, telNumber: String) {
        if name != "" {
            self.name = name
        }
        self.age = UInt(age) // maxage?
        self.telNumber = toValid(telNumber: telNumber)
//        guard name != "", let realAge = UInt(age), let realTelNumber = toValid(telNumber: telNumber) else {
//            return nil
//        }
    }
    
    private func toValid(telNumber: String) -> String? {
        let bars = telNumber.filter { ($0) == "-" }.count
        if bars != 2 || telNumber.count<10 {
            return nil
        }
        return telNumber
    }
    
    func isValid() -> String {
        if self.name == nil {
            return Validity.noName.output
        } else if self.age == nil {
            return Validity.noAge.output
        } else if self.telNumber == nil {
            return Validity.noTelNumber.output
        } else {
            return Validity.valid(self).output
        }
    }
    
    func toString() -> String {
        let result = "- \(self.name) / \(self.age) / \(self.telNumber)" ?? ""
        return result
    }
}


class InputManager: InputManagable {
    func toContact(from: String) -> Contact? {
        let splitted = from.split(separator: "/").map{removeWhiteSpaces($0)}
        guard splitted.count == 3 else { return nil }
        let contact = Contact(name: splitted[0], age: splitted[1], telNumber: splitted[2])
        let validity = contact.isValid()
        print(validity)
        if validity == Contact.Validity.valid(contact).output {
            return contact
        }
        return nil
    }
    
    func removeWhiteSpaces(_ input: Substring) -> String {
        return input.replacingOccurrences(of:" ", with:"")
    }
}


class MenuManager: MenuManagable {
    var contacts: [Contact] = []
    var inputManager: InputManagable = InputManager() //의존성주입은.. 아직 잘 이해못해서..
    
    enum Behavior {
        // 각 잘못된 정보에 대해서 띄워주는 것도 필요함
        case start, wrongChoice, needContact, needName, noInput, noContacts, programEnd
        
        var output: String {
                    switch self {
                    case .start:
                        return "1) 연락처 추가 2) 연락처 목록보기 3) 연락처 검색 x) 종료\n메뉴를 선택해주세요 : "
                    case .wrongChoice:
                        return "선택이 잘못되었습니다 확인 후 다시 입력해주세요"
                    case .needContact:
                        return "연락처 정보를 입력해주세요 : "
                    case .needName:
                        return "연락처에서 찾을 이름을 입력해주세요 : "
                    case .noInput:
                        return "아무것도 입력되지 않았습니다. 입력 형식을 확인해주세요."
                    case .noContacts:
                        return "연락처가 없습니다."
                    case .programEnd:
                        return "[프로그램 종료]"
                    }
                }
    }
    
    func printMenu() -> Bool{
        print(Behavior.start.output, terminator:"")
        let userInput: String? = readLine()
        switch userInput {
        case "1":
            addContact()
        case "2":
            printAll(contacts: contacts)
        case "3":
            searchContactWithName()
        case "x":
            print(Behavior.programEnd.output)
            return false
        default:
            print(Behavior.wrongChoice.output)
        }
        return true
    }
    
    func addContact() {
        print(Behavior.needContact.output, terminator:"")
        guard let userInput: String = readLine() else { print(Behavior.noInput.output); return }
        if userInput == "" {
            print(Behavior.noInput.output); return;
        } // 위의 코드랑 합치고싶음...
        guard let contact: Contact = inputManager.toContact(from: userInput) else { return }
        contacts.append(contact)
        contacts = contacts.sorted(by: { guard let item0 = $0.name, let item1 = $1.name else{ return false }
            return item0 < item1 })
    }
    
    func printAll(contacts: [Contact]) {
        if contacts.count == 0 {
            print(Behavior.noContacts.output)
        }
        for contact:Contact in contacts {
            print(contact.toString())
        }
    }
    func searchContactWithName() {
        print(Behavior.needName.output, terminator:"")
        guard let inputName = readLine() else { print(Behavior.noInput.output); return }
        let filteredContacts:[Contact] = contacts.filter({
            (contact: Contact) -> Bool in
            return contact.name == inputName
        })
        printAll(contacts: filteredContacts)
    }
}


let menuManger: MenuManager = MenuManager()
while menuManger.printMenu() {}
