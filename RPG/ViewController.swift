//
//  ViewController.swift
//  RPG
//
//  Created by AKI on 2015/6/24.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var mapDimX = 10   //地圖大小
        var mapDimY = 10
        
        
        var arr: [[Int]] = []
        for j in 0 ... mapDimY - 1 {
            var columnArray = Array<Int>()
            for i in 0 ... mapDimX - 1 {
                columnArray.append(0)
            }
            arr.append(columnArray)
        }
        

        var pos =  startpoint()
        pos.x = 0
        pos.y = 0
        
        var sliceVerticle : Bool = (randomInRange(0 , upper:1) == 0)

        let resultArray = genDungeon(true , dimX : mapDimX , dimY : mapDimY , arr:arr , position : pos)
        
        println("\(resultArray)")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }


    
    func genDungeon(sliceVerticle : Bool, dimX : Int , dimY : Int, arr: [[Int]], position : startpoint) -> [[Int]] {

        
        
        if(sliceVerticle){   //切垂直線  若寛不到3列就結束遞回
            if dimX < 3 {
                return arr
            }else{
                //開始切
                let wallX = randomInRange(1, upper: dimX-2) //分隔牆不允許貼邊
                //垂直牆面的出口
                let doorY = randomInRange(0, upper: dimY-1) //連接口允許貼邊
                var rtnArr: [[Int]] = []
                
                
                println("\(sliceVerticle)-\(dimX)-\(dimY)-\(position.x)-\(position.y)=\(wallX)=\(doorY)")
                
                
                
                for j in 0 ... dimY - 1 {
                    var columnArray = Array<Int>()
                    for i in 0 ... dimX - 1 {
                    
                        if i == wallX {
                            if j == doorY {
                                columnArray.append(0)  //挖一個洞
                            }else{
                                columnArray.append(1)  //我是牆
                            }
                           
                        }else{
                             columnArray.append(0)  //其他補0
                        }
                        
                       
                    }
                    rtnArr.append(columnArray)
                }
                
                //wall和door切出四個區域
               
                //======================================================
                if(doorY<1 || wallX<1){
                }else{
                
                    //左上
                    
                    
                    var arrLeftUp : [[Int]] = []
                    for i in 0 ... doorY-1 {
                        var columnArray = Array<Int>()
                        for j in 0 ... wallX-1{
                            columnArray.append(0)
                        }
                        arrLeftUp.append(columnArray)
                    }
                    
                    var posLeftUp =  startpoint()
                    
                    posLeftUp.x = 0
                    posLeftUp.y = 0
                    
                    arrLeftUp = genDungeon(!sliceVerticle, dimX : wallX , dimY : doorY, arr:arrLeftUp , position : posLeftUp)
                    
                  
                    
                    rtnArr = updateArr(rtnArr,arr2:arrLeftUp,dimX:wallX,dimY:doorY,position:posLeftUp)
                    
                   
                   
                    
                }
                
                if(doorY<1 || dimX-1 < wallX+1){
                    
                }else{
                    //======================================================
                    
                    //右上
                    var arrRightUp : [[Int]] = []
                    
                    for j in 0 ... doorY-1{
                        var columnArray = Array<Int>()
                        for i in wallX+1 ... dimX-1 {
                            columnArray.append(0)
                        }
                        arrRightUp.append(columnArray)
                    }
                    
                    var posRightUp =  startpoint()
                    
                    posRightUp.x = wallX+1
                    posRightUp.y = 0
                    
                    arrRightUp = genDungeon(!sliceVerticle, dimX : (dimX - wallX - 1) , dimY : doorY , arr:arrRightUp , position : posRightUp)
                    
                    rtnArr = updateArr(rtnArr, arr2:arrRightUp , dimX:(dimX - wallX - 1), dimY:doorY ,position:posRightUp)
                    
                    
                    //======================================================
                }
                
                if(dimY-1 < doorY + 1 || wallX < 1 ){
                    
                }else{
                    
                    //左下 //position 0, y:doorY+1 w:wallX-1 h:dimY - doorY-1
                    var arrLeftDown : [[Int]] = []
                    for j in doorY+1 ... dimY-1 {
                        var columnArray = Array<Int>()
                        for i in 0 ... wallX-1 {
                        
                            columnArray.append(0)
                        }
                        arrLeftDown.append(columnArray)
                    }
                    
                    var posLeftDown =  startpoint()
                    
                    posLeftDown.x = 0
                    posLeftDown.y = doorY + 1
                    
                    arrLeftDown = genDungeon(!sliceVerticle, dimX :wallX, dimY : dimY-doorY-1, arr:arrLeftDown , position : posLeftDown)
                    
                    
                    
                    rtnArr = updateArr(rtnArr, arr2:arrLeftDown , dimX:wallX , dimY:dimY-doorY-1,position:posLeftDown)
                    
                    
                    
                    //======================================================
                }
                
                if(dimY-1 < doorY+1 || dimX-1 < wallX+1){
                    
                }else{
                    //======================================================
                    
                    //右下
                    var arrRightDown : [[Int]] = []
                    for j in doorY + 1 ... dimY - 1 {
                        var columnArray = Array<Int>()
                        for i in wallX+1 ... dimX-1 {
                            columnArray.append(0)
                        }
                        arrRightDown.append(columnArray)
                    }
                    
                    var posRightDown =  startpoint()
                    
                    posRightDown.x = wallX + 1
                    posRightDown.y = doorY + 1
                    
                    arrRightDown = genDungeon(!sliceVerticle, dimX : (dimX - wallX - 1) , dimY : dimY-doorY-1 , arr:arrRightDown , position : posRightDown)
                    
                    
                    
                    rtnArr = updateArr(rtnArr, arr2:arrRightDown , dimX:(dimX - wallX - 1), dimY:dimY-doorY-1,position:posRightDown)
                    

                }
                
                
                
                return rtnArr

            }

        }
        else{
            if dimY < 3 {  //切水平線  若高不到3列就結束遞回
                return arr
            }
            
            //開始切
            let wallY = randomInRange(1, upper: dimY-2) //分隔牆不允許貼邊
            
            //水平牆面的出口
            let doorX = randomInRange(0, upper: dimX-1) //連接口允許貼邊
            
            println("\(sliceVerticle)-\(dimX)-\(dimY)-\(position.x)-\(position.y)=\(wallY)=\(doorX)")
            
            var rtnArr: [[Int]] = []
            for j in 0 ... dimY - 1 {
                var columnArray = Array<Int>()
                for i in 0 ... dimX - 1 {
                    if j == wallY {
                        if i == doorX {
                            columnArray.append(0)  //挖一個洞
                        }else{
                            columnArray.append(1)  //我是牆
                        }
                        
                    }else{
                        columnArray.append(0)  //其他補0
                    }
                    
                    
                }
                rtnArr.append(columnArray)
            }
            
            
            
            //wall和door切出四個區域
            
            //======================================================
            if(doorX<1 || wallY<1){
            }else{
                
                //左上
                
                var arrLeftUp : [[Int]] = []
                for j in 0 ... wallY-1{
                    var columnArray = Array<Int>()
                    for i in 0 ... doorX-1 {
                        columnArray.append(0)
                    }
                    arrLeftUp.append(columnArray)
                }
                
                var posLeftUp =  startpoint()
                
                posLeftUp.x = 0
                posLeftUp.y = 0
                
                arrLeftUp = genDungeon(!sliceVerticle, dimX:doorX , dimY:wallY, arr:arrLeftUp , position : posLeftUp)
                
                rtnArr = updateArr(rtnArr,arr2:arrLeftUp, dimX:doorX, dimY:wallY, position:posLeftUp)
                
                //======================================================
                
               
                
                
            }
            
            if(wallY<1 || dimX-1 < doorX+1){
                
            }else{
                //右上
                var arrRightUp : [[Int]] = []
                for j in 0 ... wallY-1{
                    var columnArray = Array<Int>()
                    for i in doorX+1 ... dimX-1 {
                        columnArray.append(0)
                    }
                    arrRightUp.append(columnArray)
                }
                
                var posRightUp =  startpoint()
                
                posRightUp.x = doorX+1
                posRightUp.y = 0
                
                arrRightUp = genDungeon(!sliceVerticle, dimX : (dimX - doorX - 1) , dimY : wallY , arr:arrRightUp , position : posRightUp)
                
                
                
                rtnArr = updateArr(rtnArr, arr2:arrRightUp , dimX:(dimX - doorX - 1), dimY:wallY ,position:posRightUp)
                
                
                //======================================================
            }
            
            
            if(dimY-1 < wallY+1 || doorX<1){
                
            }else{
                
                //左下
                var arrLeftDown : [[Int]] = []
                for j in wallY+1 ... dimY-1{
                    var columnArray = Array<Int>()
                    for i in 0 ... doorX-1 {
                        columnArray.append(0)
                    }
                    arrLeftDown.append(columnArray)
                }
                
                var posLeftDown =  startpoint()
                
                posLeftDown.x = 0
                posLeftDown.y = wallY + 1
                
                arrLeftDown = genDungeon(!sliceVerticle, dimX :doorX , dimY : dimY-wallY-1 , arr:arrLeftDown , position : posLeftDown)
                
                rtnArr = updateArr(rtnArr, arr2:arrLeftDown , dimX:doorX, dimY:dimY-wallY-1,position:posLeftDown)
                
                
                //======================================================
                
                
            }
            
            if(dimY-1<wallY+1 || dimX-1<doorX+1){
                
            }else{
                //右下
                var arrRightDown : [[Int]] = []
                for j in wallY+1 ... dimY-1{
                    var columnArray = Array<Int>()
                    for i in doorX+1 ... dimX-1{
                        columnArray.append(0)
                    }
                    arrRightDown.append(columnArray)
                }
                
                var posRightDown =  startpoint()
                
                posRightDown.x = doorX + 1
                posRightDown.y = wallY + 1
                
                arrRightDown = genDungeon(!sliceVerticle, dimX : (dimX - doorX - 1) , dimY : dimY-wallY-1 , arr:arrRightDown , position : posRightDown)
                
                
                
                rtnArr = updateArr(rtnArr, arr2:arrRightDown , dimX:(dimX - doorX - 1), dimY:dimY-wallY-1,position:posRightDown)
                
                
                //======================================================

            }
            
            
            
            return rtnArr
            

            
        }
        
        
        
        
        
        
        
    }
    
    
    func randomInRange (lower: Int , upper: Int) -> Int {
        
        //return Int((Double)((lower + upper) / 2 ) + 0.5)
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
    func updateArr(arr1: [[Int]], arr2: [[Int]], dimX : Int , dimY : Int ,position : startpoint) -> [[Int]]{
        
        
        var arrRtn = arr1  //mutable
        
        var i2 = 0
        var j2 = 0;
        
        //偷懶不驗證是否arr1小於arr2 與超出邊界的問題
        for i in position.x ... position.x + dimX - 1
        {
            for j in position.y ... position.y + dimY - 1
            {
                arrRtn[j][i] = arr2[j2][i2]
                j2++
            }
            j2=0
            i2++
        }
        
        
        
        
        return arrRtn
    }
    
}

struct startpoint {
    var x : Int = 0
    var y : Int = 0
}

