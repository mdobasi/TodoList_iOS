//
//  InputViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import UserNotifications

class InputViewController: UIViewController {
    private var todoInputView:TodoInputView?
    private var toDoModel:ToDoModel = ToDoModel()
    private var todoId:Int?
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// 編集時のinit
    ///
    /// - Parameter todoId: 編集するTodoのid
    convenience init(todoId:Int) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightButton))
                
        todoInputView = TodoInputView(frame: frame_Size(viewController: self), toDoModel: toDoModel, todoId: todoId)
        self.view.addSubview(todoInputView!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Todoの新規作成時はモーダルを閉じる,編集時はも一つ前の画面に戻る
    @objc func leftButton(){
        if todoId == nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /// Todoの保存、更新
    @objc func rightButton(){
        let alert = AlertManager()
        if todoInputView?.textField.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoのタイトルが入力されていません",
                              handler: { _ in return })
        }
        
        if todoInputView?.dateTextField.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoの期限が入力されていません",
                              handler: { _ in return })
        }
        
        if todoInputView?.textViwe.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoの詳細が入力されていません",
                              handler: { _ in return })
        }
        
        addNotification()
        
        if todoId != nil {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoを更新しました",
                              handler: {(action) -> Void in
                                self.todoInputView!.updateRealm()
                                self.navigationController?.popViewController(animated: true)
                                return
            })
        }
        
        
        alert.alertAction(viewController: self,
                          title: "",
                          message: "ToDoを登録しました",
                          handler: {(action) -> Void in
                            self.todoInputView!.addRealm()
                            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func addNotification() {
        
        let content:UNMutableNotificationContent = UNMutableNotificationContent()
        
        content.title = (todoInputView?.textField.text)!
        
        content.body = (todoInputView?.textViwe.text)!
        
        content.sound = UNNotificationSound.default
        
        
        //通知する日付を設定
        guard let date:Date = (todoInputView?.tmpDate) else {
            return
        }
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute] , from: date)
        
        
        let trigger:UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request:UNNotificationRequest = UNNotificationRequest.init(identifier: content.title, content: content, trigger: trigger)
        
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            
        }
        
    }

}







