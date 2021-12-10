//
//  main.swift
//  StartAssignment
//
//  Created by kakao on 2021/12/10.
//

import Foundation

protocol InputManager {
    static func getContatct()->Contact?
    static func getMenuInput()->String
    static func removeWhiteSpaces(input: String)->String
}

protocol ValidityChecker {
    static func isNameCorrect(name: String) -> String?
    static func isAgeCorrect(age: String) -> String?
    static func isNumberCorrect(number: String) -> String?
    static func isMenuNumberCorrect(menuNumber: Int) -> Int?
}

protocol MenuManager {
    var contacts: [Contact] {get set}
    mutating func printMenu()
    mutating func addContact()
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

struct InputChecker: ValidityChecker {
//      static func getValidValue<T>(_ checkFunction: (T) -> T?, _ target: T)-> T {
//          if let result = checkFunction(target) {
//              return result
//          }
//      }
    static func isNameCorrect(name: String) -> String? {
        return name
    }
    static func isAgeCorrect(age: String) -> String? {
        var intAge: Int = Int(age) ?? -1
        switch intAge{
        case 0...130:
            return age
        default:
            return nil
        }
    }
    static func isNumberCorrect(number: String) -> String? {
        return number
    }
    static func isMenuNumberCorrect(menuNumber: Int) -> Int? {
        switch menuNumber{
        case 1...4:
            return menuNumber
        default:
            return nil
        }
    }
}

struct ContactInputManager: InputManager {
    static func getContatct()->Contact? {
        var result: Contact? = nil
        print("연락처 정보를 입력해주세요 : ", terminator:"")
        var userInformation: String? = readLine()
        if let information: String = userInformation {
            var processedInformation: [String] = information.split(separator: "/").map({ (subString: Substring) -> String in
                return String(subString)
            })
//              var name = InputChecker.getValidValue(InputChecker.isNameCorrect, processedInformation[0])
//              var age = InputChecker.getValidValue(InputChecker.isAgeCorrect, processedInformation[1])
//              var number = InputChecker.getValidValue(InputChecker.isNumberCorrect, processedInformation[2])
            var name = InputChecker.isNameCorrect(name: processedInformation[0])
            var age = InputChecker.isAgeCorrect(age: processedInformation[1])
            var number = InputChecker.isNumberCorrect(number: processedInformation[2])
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
    
    static func getMenuInput() -> String {
        // code
        let name: String = " asbd"
        print(name.trimmingCharacters(in: .whitespaces))
        return "1"
    }
    
    static func removeWhiteSpaces(input: String) -> String {
        return input.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct ContactMenuManager: MenuManager {
    var contacts: [Contact] = []
    mutating func printMenu() {
        print("1) 연락처 추가 2) 연락처 목록보기 3) 연락처 검색 x) 종료\n메뉴를 선택해주세요 : ", terminator:"")
        var userInput: String? = readLine()
        if let userMenuInput = userInput  {
            let menuIndex = InputChecker.isNumberCorrect(number: userMenuInput)
            switch menuIndex {
            case "1":
                addContact()
            case "2":
                printAllContacts()
            case "3":
                searchContactWithName()
            case "x":
                return
            default:
                print("선택이 잘못되었습니다 확인 후 다시 입력해주세요")
            }
        }
    }
    mutating func addContact() {
        if let contact: Contact = ContactInputManager.getContatct() {
            contacts.append(contact)
        }
    }
    
    func printAllContacts() {
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
menuManger.printMenu()
