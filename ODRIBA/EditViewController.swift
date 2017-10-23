//
//  EditViewController.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import MediaPlayer
import SwiftRangeSlider

class EditViewController: UIViewController, MPMediaPickerControllerDelegate
{
    // 楽曲管理シングルトン
    var audioManager = AudioManager.sharedManager
    
    // 再生位置管理タイマー
    var timerPosition: Timer?

    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var musicToolBar: UIToolbar!
    
    // 受け取る用のインスタンス変数
    var navTitle: String = ""
    var colorBackground: UIColor?
    var updownFlag: Int = 0
    var isColle: Bool?
    
    // 保存用インスタンス変数
    var mediaColle: MPMediaItemCollection?
    var mediaStartTime: Double?
    var mediaEndTime: Double?
    
    // 保存ボタン設定
    let btnSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(EditViewController.saveTapAction(sender:)))
    
    // 楽曲情報イメージ・ラベル
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblSong: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    
    // 再生範囲・再生位置スライダー
    @IBOutlet weak var sliderRange: RangeSlider!
    @IBOutlet weak var sliderPosition: UISlider!
    
    // 音楽編集UIToolBarの各ボタン設定
    let btnSelect = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditViewController.musicSelectTapAction(sender:)))
    let btnPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(EditViewController.musicControllTapAction(sender:)))
    let btnPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(EditViewController.musicControllTapAction(sender:)))
    let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 再生・一時停止ボタンにタグ付け
        self.btnPlay.tag = 1
        self.btnPause.tag = 2
        
        let items = [btnSelect, flexibleItem, btnPlay, flexibleItem, btnPause]
        // UIToolBarのプロパティitemsに代入
        self.musicToolBar.items = items
        
        // NavigationBarのタイトル、保存ボタンの追加
        self.navigationItem.title = self.navTitle
        self.navigationItem.setRightBarButton(self.btnSave, animated: true)
        
        // 画面背景の設定
        self.viewEdit.backgroundColor = self.colorBackground
        
        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
        
        self.sliderRange.isHidden = true
        self.sliderPosition.isHidden = true
        
        if (!self.isColle!)
        {
            // MPMediaPickerControllerのインスタンスを作成
            let picker = MPMediaPickerController()
            // ピッカーのデリゲートを設定
            picker.delegate = self
            // 複数選択を不可にする。（trueにすると、複数選択できる）
            picker.allowsPickingMultipleItems = false
            // ピッカーを表示する
            present(picker, animated: true, completion: nil)
        }
        else
        {
            self.sliderRange.isHidden = true
            self.sliderPosition.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // 過去の楽曲情報があるなら
        if (self.audioManager.isUpColle())
        {
            self.btnSave.isEnabled = true
            
            if (self.updownFlag == 1)
            {
                let mediaColleUp = audioManager.upMusicInfo()
                self.mediaColle = mediaColleUp
                let mediaItemUp = mediaColleUp.items.first
                self.Setting(mediaItem: mediaItemUp!)
            }
        }
        else if (self.audioManager.isDownColle())
        {
            self.btnSave.isEnabled = true
            
            if (self.updownFlag == 2)
            {
                let mediaColleDown = audioManager.downMusicInfo()
                self.mediaColle = mediaColleDown
                let mediaItemDown = mediaColleDown.items.first
                self.Setting(mediaItem: mediaItemDown!)
            }
        }
        else
        {
            self.btnSave.isEnabled = false
            
            self.imgArtwork.backgroundColor = UIColor.gray
            self.lblSong.text = "楽曲情報がありません"
            self.lblAlbum.text = "楽曲情報がありません"
            self.lblArtist.text = "楽曲情報がありません"
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (!self.isColle!)
        {
            return
        }
        self.timerPosition = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changePosition), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.barStatusPause()
        self.timerPosition?.invalidate()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
     *
     *  曲情報から各部品の設定を行う
     *
     */
    @objc func changePosition()
    {
        self.sliderPosition.value = Float(self.audioManager.player.currentPlaybackTime)
        if (self.sliderPosition.value >= Float(self.sliderRange.upperValue))
        {
            self.audioManager.player.pause()
            self.barStatusPause()
            self.sliderPosition.value = Float(self.sliderRange.lowerValue)
            self.audioManager.player.currentPlaybackTime = TimeInterval(self.sliderPosition.value)
        }
    }
    
    /*
     *
     *  曲情報から各部品の設定を行う
     *
     */
    func Setting(mediaItem: MPMediaItem)
    {
        if (!self.isColle!)
        {
            return
        }
        
        
        updateSongInformationUI(mediaItem: mediaItem)
        // 再生範囲スライダーの最小値・最大値
        self.sliderRange.minimumValue = 0
        self.sliderRange.maximumValue = mediaItem.playbackDuration
        // 再生範囲スライダーの下限値・上限値
        self.sliderRange.lowerValue = 0
        self.sliderRange.upperValue = mediaItem.playbackDuration

        // 再生位置スライダーの最小値・最大値
        self.sliderPosition.minimumValue = 0
        self.sliderPosition.maximumValue = Float(mediaItem.playbackDuration)
        // 再生位置スライダーのつまみの初期位置
        self.sliderPosition.value = 0

        // 音楽の再生位置を再生範囲スライダーの下限値にする
        self.audioManager.player.currentPlaybackTime = self.sliderRange.lowerValue
    }
    
    
    /*
     *
     *メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
     *
     */
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)
    {
        self.isColle = true
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        self.audioManager.player.setQueue(with: mediaItemCollection)

        self.mediaColle = mediaItemCollection
        
        // 選択した曲から最初の曲の情報を表示
        if let mediaItem = mediaItemCollection.items.first
        {
            updateSongInformationUI(mediaItem: mediaItem)
            // 再生範囲スライダーの最小値・最大値
            self.sliderRange.minimumValue = 0
            self.sliderRange.maximumValue = mediaItem.playbackDuration
            // 再生範囲スライダーの下限値・上限値
            self.sliderRange.lowerValue = 0
            self.sliderRange.upperValue = mediaItem.playbackDuration

            // 再生位置スライダーの最小値・最大値
            self.sliderPosition.minimumValue = 0
            self.sliderPosition.maximumValue = Float(mediaItem.playbackDuration)
            // 再生位置スライダーのつまみの初期位置
            self.sliderPosition.value = 0

            // 音楽の再生位置を再生範囲スライダーの下限値にする
            //self.player.currentPlaybackTime = self.sliderRange.lowerValue
            self.audioManager.player.currentPlaybackTime = self.sliderRange.lowerValue
        }
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    /*
     *
     *  曲情報を表示する
     *
     */
    func updateSongInformationUI(mediaItem: MPMediaItem)
    {
        // 曲情報表示
        self.lblSong.text = mediaItem.title ?? "不明な曲"
        self.lblAlbum.text = mediaItem.albumTitle ?? "不明なアルバム"
        self.lblArtist.text = mediaItem.artist ?? "不明なアーティスト"
        
        self.lblSong.sizeToFit()
        self.lblAlbum.sizeToFit()
        self.lblArtist.sizeToFit()

        // アートワーク表示
        if let artwork = mediaItem.artwork
        {
            let image = artwork.image(at: self.imgArtwork.bounds.size)
            self.imgArtwork.image = image
        }
        else
        {
            // アートワークがないとき
            self.imgArtwork.image = nil
            self.imgArtwork.backgroundColor = UIColor.gray
        }
    }
    
    /*
     *
     *  選択がキャンセルされた場合に呼ばれる
     *
     */
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController)
    {
        self.sliderRange.isHidden = true
        self.sliderPosition.isHidden = true
        
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    /*
     *
     *  ミュージックライブラリアクセスボタン処理
     *
     */
    @objc func musicSelectTapAction(sender: UIBarButtonItem)
    {
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択を不可にする。（trueにすると、複数選択できる）
        picker.allowsPickingMultipleItems = false
        // ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    /*
     *
     *  再生・一時停止ボタン処理
     *
     */
    @objc func musicControllTapAction(sender: UIBarButtonItem)
    {
        switch (sender.tag)
        {
            case 1:
                // 再生ボタンが押された時
                self.sliderRange.alpha = 0.5
                self.sliderRange.isEnabled = false
                self.audioManager.player.play()
                self.btnPause.isEnabled = true
                self.btnPlay.isEnabled = false
                print("tap play")
            case 2:
                // 一時停止ボタンが押された時
                self.barStatusPause()
                print("tap pause")
            default:
                print("music select error")
        }
    }
    
    func barStatusPause()
    {
        self.audioManager.player.pause()
        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
        self.sliderRange.alpha = 1
        self.sliderRange.isEnabled = true
        self.sliderPosition.isEnabled = true
    }

    /*
     *
     *  音楽設定保存ボタン処理
     *
     */
    @objc func saveTapAction(sender: UIBarButtonItem)
    {
        self.barStatusPause()
        
        if (self.mediaColle == nil)
        {
            return
        }
        
        // アラートを作成する
        let alert = UIAlertController(title: "保存",
                                      message: "この設定を保存しますか？",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // 保存ボタンを作成する
        let saveAction = UIAlertAction(title: "保存",
                                       style: UIAlertActionStyle.default,
                                       handler:
            {
                (action:UIAlertAction) -> Void in
                
                if (self.updownFlag == 1)
                {
                    self.audioManager.saveUpItems(mediaColle: self.mediaColle!,
                                                  startTime: self.sliderRange.lowerValue,
                                                  endTime: self.sliderRange.upperValue)
                    
                }
                if (self.updownFlag == 2)
                {
                    self.audioManager.saveDownItems(mediaColle: self.mediaColle!,
                                                  startTime: self.sliderRange.lowerValue,
                                                  endTime: self.sliderRange.upperValue)
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        )
        
        // 閉じるボタンを作成する
        let cancelAction = UIAlertAction(title: "閉じる",
                                         style: UIAlertActionStyle.cancel,
                                         handler: nil)
        // アラートに保存・閉じるボタンを追加する
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // アラートを表示する
        self.present(alert,
                     animated: true,
                     completion: nil)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     *
     *  再生範囲スライダーの値変更時処理（下限値・上限値の設定）
     *
     */
    @IBAction func changeRangeValue(_ sender: RangeSlider)
    {
        if (sender.lowerValue >= Double(self.sliderPosition.value))
        {
            sender.lowerValue = Double(self.sliderPosition.value)
        }
        if (sender.upperValue < Double(self.sliderPosition.value))
        {
            sender.upperValue = Double(self.sliderPosition.value)
        }
        self.audioManager.player.currentPlaybackTime = Double(self.sliderPosition.value)
    }
    
    /*
     *
     *  再生位置スライダーの値変更時処理（曲の再生位置の更新）
     *
     */
    @IBAction func changePositionValue(_ sender: UISlider)
    {
        if (sender.value <= Float(self.sliderRange.lowerValue))
        {
            sender.value = Float(self.sliderRange.lowerValue)
        }
        if (sender.value > Float(self.sliderRange.upperValue))
        {
            sender.value = Float(self.sliderRange.upperValue)
        }
        self.audioManager.player.currentPlaybackTime = Double(sender.value)
    }
    
}
