//
//  LaunchingSence.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/27/20.
//

import UIKit

class LaunchingSence: UIViewController {
    @IBOutlet weak var textFieldPlayerName: UITextField!
    @IBOutlet weak var bottomOfTextField: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPlayerName.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3) {
                self.bottomOfTextField.constant = keyboardHeight + 20
            }
        }
    }

    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.bottomOfTextField.constant = 200
        }
    }

    @IBAction func actionPlayVsBot(_ sender: Any) {
        guard let text = textFieldPlayerName.text, !text.isEmpty else {
            Toast("Please enter your name", .bottom).show(self.view)
            return }
        MyPlayInfo.shared.name = textFieldPlayerName.text ?? ""
        navigationController?.pushViewController(VsBotBattle(), animated: true)
    }
    
    @IBAction func actionPlayVsPlayer(_ sender: Any) {
        guard let text = textFieldPlayerName.text, !text.isEmpty else {
            Toast("Please enter your name", .bottom).show(self.view)
            return }
        MyPlayInfo.shared.name = textFieldPlayerName.text ?? ""
        navigationController?.pushViewController(VsPlayerBattle(), animated: true)
    }
}

extension LaunchingSence: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            Toast("Please enter your name", .bottom).show(self.view)
            return false }
        MyPlayInfo.shared.name = text
        let _ = textField.resignFirstResponder()
        return true
    }
}
