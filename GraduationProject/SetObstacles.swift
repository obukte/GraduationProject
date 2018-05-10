import Foundation
import SpriteKit
import CoreMotion
import GameplayKit
import UIKit


class SetObstacles {
    
    var obstacle = [[Int]](repeating: [Int](repeating: 0, count: 750), count: 1334)
    
    func setObstacles(_ obstacleImage:UIImage) -> [[Int]]? {
        
        guard let inputObstCGImage = obstacleImage.cgImage else {
            print("unable to get friction cgImage")
            return nil
        }
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let width            = inputObstCGImage.width
        let height           = inputObstCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let contextObst = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create Friction context")
            return nil
        }
        
        contextObst.draw(inputObstCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let bufferObst = contextObst.data else {
            print("unable to get context data")
            return nil
        }
        
        
        let obstPixelBuffer = bufferObst.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if obstPixelBuffer[offset] == .black || obstPixelBuffer[offset] == .red{
                    obstacle[row][column] = 1
                }else if obstPixelBuffer[offset] == .blue {
                    obstacle[row][column] = -1
                }else {
                    obstacle[row][column] = 0
                }
            }
        }
        
        
        return obstacle
    }
    
    struct RGBA32: Equatable {
        private var color: UInt32
        
        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }
        
        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }
        
        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }
        
        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let R = (UInt32(red) << 24)
            let G = (UInt32(green) << 16)
            let B = (UInt32(blue) << 8)
            let A = (UInt32(alpha) << 0)
            color = R | G | B | A
        }
        
        static let black        = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let red          = RGBA32(red:150,  green: 0,   blue: 0,    alpha: 255)
        static let blue         = RGBA32(red:0,    green: 0,   blue: 150,  alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
    
}


