// created by claire pp

import Foundation

protocol InputManagable {
    func readUserInput() -> String?
    func toContact(from: String) -> Contact?
}

protocol MenuManagable {
    func run() -> Bool
    func add(from: String)
    func printAll(contacts: [Contact])
    func search(name: String) -> [Contact]
}

struct Contact {
    // 프로퍼티를 옵셔널로 선언, 각 프로퍼티 값이 유효할 때 값을 넣어줌
    var name: String?
    var age: UInt?
    var telNumber: String?
    
    enum State: String {
        case valid, noName = "이름", noAge = "나이", noTelNumber = "연락처"
    }
    
    init(name: String, age: String, telNumber: String) {
        guard name != "" else { return }
        self.name = name
        guard let age = UInt(age), age <= 100 else { return }
        self.age = age
        guard telNumber.filter({ ($0) == "-" }).count == 2, telNumber.count >= 11, telNumber.split(separator: "-").count == 3 else { return }
        // 연락처에는 "-"이 2개, 숫자는 9자리 이상(총 11자리 이상), "-"이 처음이나 마지막에 위치하거나 연속하면 안됨
        self.telNumber = telNumber
    }
    
    func toState() -> State {
        if self.name == nil {
            return State.noName
        } else if self.age == nil {
            return State.noAge
        } else if self.telNumber == nil {
            return State.noTelNumber
        } else {
            return State.valid
        }
    }
    
    func toString() -> String {
        guard let name = self.name, let age = self.age, let telNumber = self.telNumber else { return "" }
        return "- \(name) / \(age) / \(telNumber)"
    }
}


class InputManager: InputManagable {
    func readUserInput() -> String? {
        guard let userInput: String = readLine(), userInput != "" else { return nil }
        return userInput
    }
    
    func toContact(from: String) -> Contact? {
        let splitted = from.split(separator: "/").map{removeWhiteSpaces($0)}
        guard splitted.count == 3 else { return nil }
        let contact = Contact(name: splitted[0], age: splitted[1], telNumber: splitted[2])
        return contact
    }
    
    func removeWhiteSpaces(_ input: Substring) -> String {
        return input.replacingOccurrences(of:" ", with:"")
    }
}


class MenuManager: MenuManagable {
    var contacts: [Contact] = []
    var inputManager: InputManagable
    
    init(inputManager: InputManagable) {
        self.inputManager = inputManager
    }
    
    enum Behavior {
        case start, wrongChoice, wrongFormat, needContact, needName, noInput, noResults, programEnd, added(Contact), noItem(Contact.State)
        
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
            case .wrongFormat:
                return "입력 형식을 확인해주세요. ex) 홍길동/30/010-1234-5678"
            case .noItem(let state):
                return "입력한 \(state.rawValue) 정보가 잘못되었습니다. 입력 형식을 확인해주세요."
            case .noResults:
                return "연락처가 없습니다."
            case .programEnd:
                return "[프로그램 종료]"
            case .added(let contact): // case let .added(contact)
                guard let name = contact.name, let age = contact.age, let telNumber = contact.telNumber else { return "" }
                return "입력한 정보는 \(age)세 \(name)(\(telNumber))입니다."
            }
        }
    }
    
    enum Command: String {
        case add = "1", list = "2", search = "3", end = "x"
    }
    
    func run() -> Bool{
        guard let menuInput: String = read(message: Behavior.start.output) else { return true }
        switch menuInput {
        case Command.add.rawValue:
            guard let userInput = read(message: Behavior.needContact.output) else { return true }
            add(from: userInput)
            
        case Command.list.rawValue:
            printAll(contacts: contacts)
            
        case Command.search.rawValue:
            guard let name = read(message: Behavior.needName.output) else { return true }
            let searchResults = search(name: name)
            printAll(contacts: searchResults)
            
        case Command.end.rawValue:
            print(Behavior.programEnd.output)
            return false
            
        default:
            print(Behavior.wrongChoice.output)
        }
        return true
    }
    
    func read(message: String) -> String? {
        print(message, terminator:"")
        guard let userInput: String = inputManager.readUserInput() else { print(Behavior.noInput.output); return nil }
        return userInput
    }
    
    func add(from: String) {
        guard let contact: Contact = inputManager.toContact(from: from) else { print(Behavior.wrongFormat.output); return }
        if contact.toState() != Contact.State.valid {
            print(Behavior.noItem(contact.toState()).output)
            return
        }
        print(Behavior.added(contact).output)
        contacts.append(contact)
        contacts = contacts.sorted(by: {
            guard let item0 = $0.name, let item1 = $1.name else {
                return false
            }
            return item0 < item1 })
    }
    
    func printAll(contacts: [Contact]) {
        if contacts.count == 0 {
            print(Behavior.noResults.output)
        }
        for contact:Contact in contacts {
            print(contact.toString())
        }
    }
    
    func search(name: String) -> [Contact] {
        let filteredContacts:[Contact] = contacts.filter({
            (contact: Contact) -> Bool in
            guard let nameInContact = contact.name else { return false }
            return nameInContact == name
        })
        return filteredContacts
    }
}


let menuManger: MenuManager = MenuManager(inputManager: InputManager())
while menuManger.run() { print() }
