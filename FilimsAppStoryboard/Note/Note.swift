//
//  Note.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 18/04/23.
//

import Foundation

/*
 вычисление хэш суммы полученных данных
 
 import Foundation
 import CryptoKit

 func calculateSHA256(data: Data) -> String {
     let hashedData = SHA256.hash(data: data)
     let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
     return hashString
 }

 func compareJSONDataWithHash(firstData: Data, secondData: Data) -> Bool {
     let firstHash = calculateSHA256(data: firstData)
     let secondHash = calculateSHA256(data: secondData)
     
     return firstHash == secondHash
 }

 // Пример использования
 let firstData = """
 {
     "name": "John",
     "age": 30,
     "country": "USA"
 }
 """.data(using: .utf8)!

 let secondData = """
 {
     "name": "John",
     "age": 30,
     "country": "USA"
 }
 """.data(using: .utf8)!

 let thirdData = """
 {
     "name": "Jane",
     "age": 25,
     "country": "Canada"
 }
 """.data(using: .utf8)!

 let isSame = compareJSONDataWithHash(firstData: firstData, secondData: secondData)
 print("Are the first and second JSON data the same? \(isSame)") // Output: Are the first and second JSON data the same? true

 let isSame2 = compareJSONDataWithHash(firstData: firstData, secondData: thirdData)
 print("Are the first and third JSON data the same? \(isSame2)") // Output: Are the first and third JSON data the same? false
 
 */
/* For first add object to data base
let filmOb = FilmObject()
filmOb.id = 3
do {
    try! realm?.write({
        realm?.add(filmOb, update: .all)
    })
} catch {
    print(" ++ error \(error.localizedDescription)")
}
 */

/*Search in simple array
 func search(searchTextValue: String) {
//        newTestArray = []
//
//        if searchTextValue == "" {
//            newTestArray = testArray
//        } else {
//            for item in testArray {
//                guard let unwrItem = item.testTitle else {
//                    return
//                }
//
//                if unwrItem.contains(searchTextValue) {
//                    newTestArray.append(item)
//                }
//            }
//        }
//
//        newTestArray = testArray.filter({
//            $0.testTitle?.range(of: searchTextValue, options: .caseInsensitive) != nil
//        })
 }
 */
