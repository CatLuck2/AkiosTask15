//
//  ViewController.swift
//  AkiosTask15
//
//  Created by Nekokichi on 2020/08/22.
//  Copyright © 2020 Nekokichi. All rights reserved.
//
/*
 UserDefaultに保存
    いつ保存する？
        チェック項目を編集した時
        データを追加した時
    どのように保存する？
        タプルで保存
 */

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet private weak var checkListTableView: UITableView!

    private let ud = UserDefaults.standard
    //チェックリスト（タプルの配列）
    private var checkList:Array<(text:String, keyCheck:Bool)> = []
    //チェックリスト（UserDefault保存用）
    private var checkListForUD:Array<Dictionary<String, Any>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaultからデータを取得
        if let checkListData = ud.object(forKey: "checkList") as? [[String: Any]] {
            for i in 0..<checkListData.count {
                checkList.append(convertToTupleFromDictionary(dictionary: checkListData[i]))
            }
        }
        
        //checkListTableViewの設定
        checkListTableView.delegate   = self
        checkListTableView.dataSource = self
        checkListTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")
    }
    
    
    /* TableView */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CustomCellを生成
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        //CustomCell内のUIに値を入れる
        cell.configure(text: checkList[indexPath.row].text, keyCheck: checkList[indexPath.row].keyCheck)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //チェック状態を反転させる
        checkList[indexPath.row].keyCheck.toggle()
        
        //UserDefaultに保存
        for i in 0..<checkList.count {
            checkListForUD.append(convertToDictionaryFromTuple(tuple: checkList[i]))
        }
        ud.set(checkListForUD, forKey: "checkList")
        //初期化
        checkListForUD = [[String: Any]]()
        
        //checkListTableViewの表示を更新
        checkListTableView.deselectRow(at: indexPath, animated: true)
        checkListTableView.reloadData()
    }
    /* TableView */
    
    
    @IBAction func unwindToVC(_ unwindSegue: UIStoryboardSegue) {
        //AddCheckItemで追加ボタンが押下された時
        if unwindSegue.identifier == "addItem" {
            //チェック項目を追加
            let addCheckItemVC = unwindSegue.source as! AddCheckItem
            checkList.append(addCheckItemVC.checkItem)
            
            //UserDefaultに保存
            for i in 0..<checkList.count {
                checkListForUD.append(convertToDictionaryFromTuple(tuple: checkList[i]))
            }
            ud.set(checkListForUD, forKey: "checkList")
            //初期化
            checkListForUD = [[String: Any]]()
            
            //checkListTableViewを更新
            checkListTableView.reloadData()
        }
    }
    
    //タプル -> 辞書に変換
    func convertToDictionaryFromTuple(tuple: (text:String, keyCheck:Bool)) -> [String: Any] {
        return [
            "text"     : tuple.text,
            "keyCheck" : tuple.keyCheck
        ]
    }
    
    //辞書 -> タプルに変換
    func convertToTupleFromDictionary(dictionary: [String: Any]) -> (text:String, keyCheck:Bool) {
        let checkItemTextData = dictionary["text"] as! String
        var checkItemKeyData  = Bool()
        
        //Bool値を算出
        if dictionary["keyCheck"] as? Int == 0 {
            checkItemKeyData = false
        }
        if dictionary["keyCheck"] as? Int == 1 {
            checkItemKeyData = true
        }
        
        return (
            text    : checkItemTextData,
            keyCheck: checkItemKeyData
        )
    }

}

