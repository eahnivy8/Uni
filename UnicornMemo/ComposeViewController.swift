

import UIKit

extension NSNotification.Name {
    static let memoDidInsert = NSNotification.Name(rawValue: "MemoDidInsert")
    static let memoDidEdit = NSNotification.Name(rawValue: "MemoDidEdit")
}

class ComposeViewController: UIViewController {
    var editTarget: MemoEntity?
    var originalMemoContent: String?
    
    @IBOutlet weak var textView: UITextView!
    @objc func saveMemo(_ sender: Any) {
        guard let text = textView.text, text.count > 0 else {
            let alert = UIAlertController(title: "Alert", message: "Require contents!", preferredStyle:.alert)
            let ok = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
                self?.textView.becomeFirstResponder()
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
            return }
        if let memo = editTarget {
            memo.content = text
            CoreDataManager.shared.saveContext()
            NotificationCenter.default.post(name: .memoDidEdit, object: nil)
        } else {
            CoreDataManager.shared.createMemo(content: text)
            NotificationCenter.default.post(name: .memoDidInsert, object: nil)
        }
        self.cancelMemo(sender)
    }
    @objc func cancelMemo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.becomeFirstResponder()
        let saveButton = UIButton(type: UIButton.ButtonType.custom)
        saveButton.setImage(UIImage(named: "save.png"), for: .normal)
        saveButton.imageEdgeInsets = .init(top: 32, left: 32, bottom: 32, right: 32)
        saveButton.addTarget(self, action: #selector(saveMemo), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItems = [rightBarButton]
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setImage(UIImage(named: "cancel.png"), for: .normal)
        cancelButton.imageEdgeInsets = .init(top: 32, left: 32, bottom: 32, right: 32)
        cancelButton.addTarget(self, action: #selector(cancelMemo), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
        
        if let memo = editTarget {
            self.navigationItem.title = "Edit Memo"
            textView.text = memo.content
            originalMemoContent = memo.content
        } else {
            self.navigationItem.title = "New Memo"
            textView.text = ""
        }
        textView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.textView.contentInset
                inset.bottom = height
                strongSelf.textView.contentInset = inset
                
                inset = strongSelf.textView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.textView.scrollIndicatorInsets = inset
            }
        })
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            var inset = strongSelf.textView.contentInset
            inset.bottom = 0
            strongSelf.textView.contentInset = inset
            
            inset = strongSelf.textView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.textView.scrollIndicatorInsets = inset
            
        })
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
        
    }
    
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to save?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
            self?.saveMemo(action)
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No", style: .cancel) {
            [weak self] (action) in
            self?.cancelMemo(action)
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

