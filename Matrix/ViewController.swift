//
//  ViewController.swift
//  Matrix
//
//  Created by Jay on 16/3/20.
//  Copyright © 2016年 Jay. All rights reserved.
//

import UIKit

struct Cmatrix {
    var text: Int?
    var isHide: Bool?
    init(text :Int, isHide: Bool) {
        self.text = text
        self.isHide = isHide
    }
}

let show_characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=/?\\|[]{}:;\"'.,`~"
let show_length = show_characters.characters.count
// 更新速度
let speed = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.5, 0.6, 0.7, 0.8]
let speed_num = speed.count
var current_speed_level = 3
// 文本颜色
let text_color = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
let back_color = UIColor(red: 4.0/255.0, green: 24.0/255.0, blue: 31.0/255.0, alpha: 1)
let font_size = 16.0
let space_size = 2.0

class MyTextView:UITextView {
    var matrix: [Cmatrix]?
    var matrix_num: Int?
    var show_num: Int?
    var timer:NSTimer?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func get_matrix_text() -> String{
        var ss:String = ""
        for m in matrix! {
            ss.append((m.isHide! == true) ?  "\n" : ([Character](show_characters.characters)[m.text!]))
        }
        return ss
    }
    
    // 定时执行的函数
    func tickDown() {
        // 更新显示状态，在状态变为hide时更改值
        for i in 0..<(matrix_num!-1) {
            matrix![matrix_num! - 1 - i].isHide = matrix![matrix_num! - 2 - i].isHide!
            if matrix![matrix_num! - 1 - i].isHide! == true {
                matrix![matrix_num! - 1 - i].text = Int(arc4random_uniform(UInt32(show_length)))
            }
        }
        
        // 更改一段时间内显示的数目
        show_num = show_num! - 1
        if (show_num! <= 0) {
            // 减少到0时，表明需要更换是否显示的标志，并更改显示数目
            show_num = Int(arc4random_uniform(UInt32(matrix_num!)))
            matrix![0].isHide = !(matrix![0].isHide!)
        }
        // 更新文本
        text = get_matrix_text()
    }

    init(frame: CGRect, matrix_num: Int) {
        matrix = []
        show_num = Int(arc4random_uniform(UInt32(matrix_num)))
        for _ in 0..<matrix_num {
            matrix?.append(Cmatrix(text: Int(arc4random_uniform(UInt32(show_length))), isHide: true))
        }
        super.init(frame: frame, textContainer: nil)
        
        // 随机更改第一个的显示状态
        matrix![0].isHide = (arc4random_uniform(100) > 50 ? true : false)

        self.matrix_num = matrix_num
        backgroundColor = UIColor.clearColor()
        textColor = text_color
        font = UIFont(name: "Menlo", size: CGFloat(font_size))
        scrollEnabled = false
        selectable = false
        text = get_matrix_text()
        editable = false
        // 注册更新计时器事件
        timer = NSTimer.scheduledTimerWithTimeInterval(speed[current_speed_level],
                                                       target:self,selector:#selector(MyTextView.tickDown),
                                                       userInfo:nil,repeats:true)
    }
}

class ViewController: UIViewController {
    var screen_height: Double?
    var screen_width: Double?
    
    var column_num = 0
    var row_num = 0
    
    var line_array: NSMutableArray?
    var x = 0
    var y = 0
    
    func addTextViews() {
        // 获取屏幕大小
        screen_width  = Double(UIScreen.mainScreen().bounds.width)
        screen_height = Double(UIScreen.mainScreen().bounds.height)
        print("screen width:\(screen_width)")
        print("screen height:\(screen_height)")
        
        // 计算行列数目
        column_num = Int(screen_width! / (font_size + space_size))
        row_num    = Int(screen_height! / font_size)
        print("col:\(column_num)")
        print("row:\(row_num)")
        
        // 计算第一个位置
        x = Int((screen_width! - (font_size+space_size) * Double(column_num) + space_size) / 2)
        y = Int((screen_height! - font_size * Double(row_num)) / 2)
        print("x:\(x)")
        print("y:\(y)")
        
        let text_view_height = Int(screen_height! - Double(y) * 2.0)
        print("text_view_height:\(text_view_height)")
        
        // 初始化line_array
        for i in 0..<column_num {
            
            let xi = x + (i * Int(font_size + space_size))
            let text_view = MyTextView(frame: CGRectMake(CGFloat(xi), CGFloat(y), CGFloat(font_size), CGFloat(text_view_height)), matrix_num: row_num)
            self.view.addSubview(text_view)
        }
    }
    
//    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
//        //划动的方向
//        let direction = sender.direction
//        //判断是上下左右
//        switch (direction){
//        case UISwipeGestureRecognizerDirection.Right:
//            print("Right")
//            break
//        case UISwipeGestureRecognizerDirection.Up:
//            print("Up")
//            current_speed_level -= 1
//            if current_speed_level < 0 {
//                current_speed_level = 0
//            }
//            break
//        case UISwipeGestureRecognizerDirection.Left:
//            print("Left")
//            break
//        case UISwipeGestureRecognizerDirection.Down:
//            print("Down")
//            current_speed_level += 1
//            if current_speed_level >= speed_num {
//                current_speed_level = speed_num - 1
//            }
//            break
//        default:
//            break;
//        }
//        // 更新时间
////        let textviews = view.subviews
////        for v in textviews {
////            (v as! MyTextView).timer!.invalidate()
////            (v as! MyTextView).timer = NSTimer.scheduledTimerWithTimeInterval(speed[current_speed_level],
////                                                       target:self,selector:#selector(MyTextView.tickDown),
////                                                       userInfo:nil,repeats:true)
////        }
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = back_color
        
        // 移除其他视图
        let views2remove = view.subviews
        for v in views2remove {
            v.removeFromSuperview()
        }
        
        addTextViews()
        
        // 添加手势
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
//        self.view.addGestureRecognizer(swipeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // 处理旋转事件
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // 移除之前的视图
        let views2remove = view.subviews
        for v in views2remove {
            v.removeFromSuperview()
        }
        // 重新生成textView
        addTextViews()
    }
    
    // 处理手势事件
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
    }
}

