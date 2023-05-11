//
//  ViewController.swift
//  MeiroGame
//
//  Created by 白川創大 on 2023/05/12.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    var playerView: UIView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    
    
    let screenSize = UIScreen.main.bounds.size
    
    let maze = [
        [1,0,0,0,1,0],
        [1,0,1,0,1,0],
        [3,0,1,0,1,0],
        [1,1,1,0,0,0],
        [1,0,0,1,1,0],
        [0,0,1,0,0,0],
        [0,1,1,0,1,0],
        [0,0,0,0,1,1],
        [0,1,1,0,0,0],
        [0,0,1,1,1,2],
    ]
    
    var startView: UIView!
    var goalView: UIView!
    
    func createView(x: Int, y: Int, width: CGFloat, height: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> UIView  {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
        
        view.center = center
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellWidth = screenSize.width / CGFloat(maze[0].count)
        let cellHeight = screenSize.height / CGFloat(maze.count)
        
        let celloffsetX = cellWidth / 2
        let celloffsetY = cellHeight / 2
        
        view.backgroundColor = UIColor(red: 255, green: 255, blue: 240, alpha: 1.0)
        
        
        for y in 0 ..< maze.count{
            for x in 0 ..< maze[y].count {
                switch maze[y][x] {
                    
                case 1:
                    let wallView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: celloffsetX, offsetY: celloffsetY)
                    wallView.backgroundColor = UIColor.gray
                    view.addSubview(wallView)
                    
                case 2:
                    startView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: celloffsetX, offsetY: celloffsetY)
                    startView.backgroundColor = UIColor.green
                    view.addSubview(startView)
                    
                case 3:
                    goalView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: celloffsetX, offsetY: celloffsetY)
                    goalView.backgroundColor = UIColor.red
                    view.addSubview(goalView)
                    
                default:
                    break
                    
                }
                
            }
            // Do any additional setup after loading the view.
        }
        
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth / 6, height: cellHeight / 6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        view.addSubview(playerView)
        
        
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        
        startAccelerometer()
        
    }
    
    func startAccelerometer() {
        let handler: CMAccelerometerHandler = { (CMAccelerometerData: CMAccelerometerData?, error: Error?) -> Void in
            self.speedX += CMAccelerometerData!.acceleration.x
            self.speedY += CMAccelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y + (CGFloat(self.speedY) / 3)
            
            if posX <= self.playerView.frame.width / 2 {
                self.speedX = 0
                posX = self.playerView.frame.width / 2
            }
            if posY <= self.playerView.frame.height / 2 {
                self.speedX = 0
                posY = self.playerView.frame.height / 2
            }
            if posX >= self.screenSize.width - (self.playerView.frame.width / 2){
                self.speedX = 0
                posX = self.screenSize.width - (self.playerView.frame.width / 2)
            }
            if posY >= self.screenSize.height - (self.playerView.frame.height / 2){
                self.speedY = 0
                posY = self.screenSize.height - (self.playerView.frame.height / 2)
            }
            self.playerView.center = CGPoint(x: posX, y: posY)
            
        }
        playerMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler:  handler)
    }
    
    
}
