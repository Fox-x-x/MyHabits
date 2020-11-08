//
//  LoadTextFromFile.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 07.11.2020.
//

import UIKit

extension UITextView {
    // загружает текст из текстового файла
    func loadTextFromFile(_ fileName: String) -> String {
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
          do {
            let text = try String(contentsOfFile: path, encoding: .utf8)
            return text
          } catch let error {
            print(" Error - \(error.localizedDescription)")
          }
        }
        return ""
    }
}
