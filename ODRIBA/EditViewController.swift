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

    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var musicToolBar: UIToolbar!
    
    // 受け取る用のインスタンス変数
    var navTitle: String = ""
    var colorBackground: UIColor?
    
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
        
        // 過去の楽曲情報があるなら
//        if (self.audioManager.mediaItem != nil)
//        {
//            self.Setting()
//        }
        
//        var timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changePosition), userInfo: nil, repeats: true)
        
        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
//        self.rangeSlider.alpha = 1
//        self.rangeSlider.isEnabled = true
//        self.scrubSlider.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
//        self.audioManager.player.pause()
        self.barStatusPause()
//        self.audioManager.player.currentPlaybackTime = self.audioManager.startTime!
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
    func changePosition()
    {
//        self.scrubSlider.value = Float(self.audioManager.player.currentPlaybackTime)
//        if (self.scrubSlider.value >= Float(self.rangeSlider.upperValue))
//        {
//            self.barStatusPause()
//        }
    }
    
    /*
     *
     *  曲情報から各部品の設定を行う
     *
     */
    func Setting()
    {
//        updateSongInformationUI(mediaItem: self.audioManager.mediaItem!)
//        // 再生範囲スライダーの最小値・最大値
//        self.rangeSlider.minimumValue = 0
//        self.rangeSlider.maximumValue = (self.audioManager.mediaItem?.playbackDuration)!
//        // 再生範囲スライダーの下限値・上限値
//        self.rangeSlider.lowerValue = 0
//        self.rangeSlider.upperValue = (self.audioManager.mediaItem?.playbackDuration)!
//
//        self.audioManager.ChangeStartTime(start: self.rangeSlider.lowerValue)
//        self.audioManager.ChangeEndTime(end: self.rangeSlider.upperValue)
//
//        // 再生位置スライダーの最小値・最大値
//        self.scrubSlider.minimumValue = 0
//        self.scrubSlider.maximumValue = Float((self.audioManager.mediaItem?.playbackDuration)!)
//        // 再生位置スライダーのつまみの初期位置
//        self.scrubSlider.value = 0
//
//        // 音楽の再生位置を再生範囲スライダーの下限値にする
//        self.audioManager.player.currentPlaybackTime = self.rangeSlider.lowerValue
    }
    
    
    /*
     *
     *メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
     *
     */
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)
    {
//        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
//        //self.player.setQueue(with: mediaItemCollection) //
//        self.audioManager.player.setQueue(with: mediaItemCollection)
//
//        // 選択した曲から最初の曲の情報を表示
//        if let mediaItem = mediaItemCollection.items.first  //
//        {
//            self.audioManager.mediaItem = mediaItem
//            updateSongInformationUI(mediaItem: self.audioManager.mediaItem!)
//            // 再生範囲スライダーの最小値・最大値
//            self.rangeSlider.minimumValue = 0
//            self.rangeSlider.maximumValue = (self.audioManager.mediaItem?.playbackDuration)!
//            // 再生範囲スライダーの下限値・上限値
//            self.rangeSlider.lowerValue = 0
//            self.rangeSlider.upperValue = (self.audioManager.mediaItem?.playbackDuration)!
//
//            self.audioManager.ChangeStartTime(start: self.rangeSlider.lowerValue)
//            self.audioManager.ChangeEndTime(end: self.rangeSlider.upperValue)
//
//            // 再生位置スライダーの最小値・最大値
//            self.scrubSlider.minimumValue = 0
//            self.scrubSlider.maximumValue = Float((self.audioManager.mediaItem?.playbackDuration)!)
//            // 再生位置スライダーのつまみの初期位置
//            self.scrubSlider.value = 0
//
//            // 音楽の再生位置を再生範囲スライダーの下限値にする
//            //self.player.currentPlaybackTime = self.rangeSlider.lowerValue
//            self.audioManager.player.currentPlaybackTime = self.rangeSlider.lowerValue
//        }
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
//        // 曲情報表示
//        self.lblArtist.text = mediaItem.artist ?? "不明なアーティスト"
//        self.lblAlbum.text = mediaItem.albumTitle ?? "不明なアルバム"
//        self.lblSong.text = mediaItem.title ?? "不明な曲"
//
//        // アートワーク表示
//        if let artwork = mediaItem.artwork
//        {
//            let image = artwork.image(at: self.imgArtwork.bounds.size)
//            self.imgArtwork.image = image
//        }
//        else
//        {
//            // アートワークがないとき
//            self.imgArtwork.image = nil
//            self.imgArtwork.backgroundColor = UIColor.gray
//        }
    }
    
    /*
     *
     *  選択がキャンセルされた場合に呼ばれる
     *
     */
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController)
    {
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
//                self.rangeSlider.alpha = 0.5
//                self.rangeSlider.isEnabled = false
//                self.audioManager.player.play()
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
//        self.audioManager.player.pause()
        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
//        self.rangeSlider.alpha = 1
//        self.rangeSlider.isEnabled = true
//        self.scrubSlider.isEnabled = true
    }

    /*
     *
     *  音楽設定保存ボタン処理
     *
     */
    @objc func saveTapAction(sender: UIBarButtonItem)
    {
        
    }
    
    /*
     *
     *  再生範囲スライダーの値変更時処理（下限値・上限値の設定）
     *
     */
    @IBAction func changeRangeValue(_ sender: RangeSlider)
    {
//        if (sender.lowerValue >= Double(self.scrubSlider.value))
//        {
//            sender.lowerValue = Double(self.scrubSlider.value)
//            self.audioManager.ChangeStartTime(start: sender.lowerValue)
//        }
//        if (sender.upperValue < Double(self.scrubSlider.value))
//        {
//            sender.upperValue = Double(self.scrubSlider.value)
//            self.audioManager.ChangeEndTime(end: sender.upperValue)
//        }
//        self.audioManager.player.currentPlaybackTime = Double(self.scrubSlider.value)
    }
    
    /*
     *
     *  再生位置スライダーの値変更時処理（曲の再生位置の更新）
     *
     */
    @IBAction func changePositionValue(_ sender: UISlider)
    {
//        if (sender.value <= Float(self.rangeSlider.lowerValue))
//        {
//            sender.value = Float(self.rangeSlider.lowerValue)
//        }
//        if (sender.value > Float(self.rangeSlider.upperValue))
//        {
//            sender.value = Float(self.rangeSlider.upperValue)
//        }
//        self.audioManager.player.currentPlaybackTime = Double(sender.value)
    }
    
}
