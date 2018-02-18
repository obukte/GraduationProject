
import Foundation
import SpriteKit
import CoreMotion
import GameplayKit
import UIKit


class SetHeight {
    
    var heightMp = [[Int]](repeating: [Int](repeating: 0, count: 750), count: 1334)
    
    func createHeightMap(_ heightImage:UIImage) -> [[Int]]? {
        
        guard let inputHeightCGImage = heightImage.cgImage else {
            print("unable to get friction cgImage")
            return nil
        }
        
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let width            = inputHeightCGImage.width
        let height           = inputHeightCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let contextHeight = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create Friction context")
            return nil
        }
        
        contextHeight.draw(inputHeightCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let bufferHeight = contextHeight.data else {
            print("unable to get context data")
            return nil
        }
        
        
        let heightPixelBuffer = bufferHeight.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if (Int(heightPixelBuffer[offset].redComponent) == 0) && (Int(heightPixelBuffer[offset].blueComponent) == 0) {
                    if (Int(heightPixelBuffer[offset].greenComponent) < 128) {
                        heightMp[row][column] = -(127 - Int(heightPixelBuffer[offset].greenComponent))
                    } else {
                        heightMp[row][column] = (Int(heightPixelBuffer[offset].greenComponent) - 128)
                    }
                }
            }
        }
        return heightMp
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
        
        static let fRedOne    = RGBA32(red:150,  green: 0,   blue: 0,    alpha: 255)
        static let fRedTwo    = RGBA32(red:200,  green: 0,   blue: 0,    alpha: 255)
        static let fRedThree  = RGBA32(red:240,  green: 0,   blue: 0,    alpha: 255)
        static let fBlueOne   = RGBA32(red:0,    green: 0,   blue: 150,  alpha: 255)
        static let fBlueTwo   = RGBA32(red:0,    green: 0,   blue: 200,  alpha: 255)
        static let fBlueThree = RGBA32(red:0,    green: 0,   blue: 240,  alpha: 255)
        static let fYllwOne   = RGBA32(red:255,  green: 255, blue: 0,    alpha: 255)
        static let fYllwTwo   = RGBA32(red:255,  green: 220, blue: 0,    alpha: 255)
        static let fGreenOne  = RGBA32(red:0,    green: 160, blue: 0,    alpha: 255)
        static let fGreenTwo  = RGBA32(red:0,    green: 200, blue: 0,    alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
    
}


