//
//  EditViewController.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import MediaPlayer

class EditViewController: UIViewController, MPMediaPickerControllerDelegate
{

    @IBOutlet weak var navItems: UINavigationItem!
    @IBOutlet weak var musicToolBar: UIToolbar!
    
    // 音楽編集UIToolBarの各ボタン設定
    let btnSelect = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.done, target: self, action: #selector(EditViewController.musicControllTapAction(sender:)))
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

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
     *
     *  ミュージックライブラリアクセスボタン処理
     *
     */
    func selectTapAction(sender: UIButton)
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
     *  再生・一時停止ボタン処理
     *
     */
    @objc func musicControllTapAction(sender: UIButton)
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
//                self.audioManager.player.pause()
                self.btnPause.isEnabled = false
                self.btnPlay.isEnabled = true
//                self.rangeSlider.alpha = 1
//                self.rangeSlider.isEnabled = true
//                self.scrubSlider.isEnabled = true
                print("tap pause")
            default:
                print("music select error")
        }
    }

    /*
     *
     *  音楽設定保存ボタン処理
     *
     */
    @IBAction func btnSaveAction(_ sender: Any)
    {
        
    }
    
    /*
     *
     *  戻るボタン処理
     *
     */
    @IBAction func btnBackAction(_ sender: Any)
    {
//        self.audioManager.player.pause()
//        self.audioManager.player.currentPlaybackTime = self.audioManager.startTime!
        self.dismiss(animated: true, completion: nil)
    }
    

}
