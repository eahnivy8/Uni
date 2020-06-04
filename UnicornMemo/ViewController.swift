//
//  ViewController.swift
//  UnicornMemo
//
//  Created by Eddie Ahn on 2020/04/27.
//  Copyright © 2020 Sang Wook Ahn. All rights reserved.
//

import UIKit
import MessageUI
import FBAudienceNetwork

class ViewController: UIViewController, FBAdViewDelegate {
    var bannerAdView: FBAdView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    var buttonActive = true
    @IBAction func editButtonAction(_ sender: UIButton) {
        
        if buttonActive {
            listTableView.setEditing(true, animated: true)
            editButton.setImage(UIImage(named: "done.png"), for: .normal)
            composeButton.isHidden = true
        } else {
            listTableView.setEditing(false, animated: true)
            editButton.setImage(UIImage(named: "edit.png"), for: .normal)
            composeButton.isHidden = false
        }
        buttonActive = !buttonActive
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd EEE"
        return formatter
    }()
    
    //@IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.memo = CoreDataManager.shared.list[indexPath.row]
            }
        }
    }
    func sendEmail(with data: String) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("Mail")
        composer.setMessageBody(data, isHTML: false)
        present(composer, animated: true, completion: nil)
    }
    func sendMessage(with data: String) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = self
        composer.body = data
        present(composer, animated: true, completion: nil)
    }
    func delete(at indexPath: IndexPath) {
        let target = CoreDataManager.shared.list[indexPath.row]
        CoreDataManager.shared.context.delete(target)
        CoreDataManager.shared.saveContext()
        CoreDataManager.shared.list.remove(at: indexPath.row)
        listTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerAdView = FBAdView(placementID: "177353010371214_177353813704467", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        bannerAdView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 80 , width: UIScreen.main.bounds.size.width, height: 50.0)
        bannerAdView.delegate = self
        bannerAdView.isHidden = false
        self.view.addSubview(bannerAdView)
        bannerAdView.loadAd()
        listTableView.backgroundColor = .clear
        CoreDataManager.shared.fetchMemo()
        
        NotificationCenter.default.addObserver(forName: .memoDidInsert, object: nil, queue: .main) { [weak self] _ in
            let index = IndexPath(row: 0, section: 0)
            self?.listTableView.insertRows(at: [index], with: .automatic)
        }
        NotificationCenter.default.addObserver(forName: .memoDidDelete, object: nil, queue: .main) { [weak self] (_) in
            self?.listTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: .memoDidEdit, object: nil, queue: .main) { [weak self] (_) in
            self?.listTableView.reloadData()
        }
        
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataManager.shared.list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = CoreDataManager.shared.list[indexPath.row].content
        cell.detailTextLabel?.text = dateFormatter.string(for: CoreDataManager.shared.list[indexPath.row].date)
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         return true
     }
    //원하는 위치에 drop하면 이위치에 드랍됨.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = CoreDataManager.shared.list[sourceIndexPath.row]
        CoreDataManager.shared.list.remove(at: sourceIndexPath.row)
        CoreDataManager.shared.list.insert(movedObject, at: destinationIndexPath.row)
        
        var postionStart = 0
        
        for item in CoreDataManager.shared.list {
            item.positionInTable = Int32(postionStart)
            postionStart += 1
        }
        CoreDataManager.shared.saveContext()

    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let emailAction = UITableViewRowAction(style: .default, title: "email") { [weak self] (action, indexPath) in
            if let data = CoreDataManager.shared.list[indexPath.row].content {
                self?.sendEmail(with: data)
            }
        }
        emailAction.backgroundColor = .systemGreen
        let messageAction = UITableViewRowAction(style: .normal, title: "Text") { [weak self] (action, indexPath) in
            if let data = CoreDataManager.shared.list[indexPath.row].content {
                self?.sendMessage(with: data)
            }
        }
        messageAction.backgroundColor = .systemTeal
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self](action, indexPath) in
            self?.delete(at: indexPath)
        }
        return [deleteAction, messageAction, emailAction]
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}


