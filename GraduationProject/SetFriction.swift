import Foundation
import SpriteKit
import CoreMotion
import GameplayKit
import UIKit


class SetFriction {
    
    var friction = [[Double]](repeating: [Double](repeating: 0.0, count: 750), count: 1334)
    
    func createFrictionMap(_ frictionImage:UIImage) -> [[Double]]? {
        
        guard let inputFricCGImage = frictionImage.cgImage else {
            print("unable to get friction cgImage")
            return nil
        }
        
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let width            = inputFricCGImage.width
        let height           = inputFricCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let contextFrict = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create Friction context")
            return nil
        }
        
        contextFrict.draw(inputFricCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let bufferFrict = contextFrict.data else {
            print("unable to get context data")
            return nil
        }
        
        
        let fricPixelBuffer = bufferFrict.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if (fricPixelBuffer[offset] == .fRedOne) || (fricPixelBuffer[offset] == .fBlueOne) {
                    friction[row][column] = 0.2
                } else if (fricPixelBuffer[offset] == .fRedTwo) || (fricPixelBuffer[offset] == .fBlueTwo) {
                    friction[row][column] = 0.4
                } else if (fricPixelBuffer[offset] == .fRedThree) || (fricPixelBuffer[offset] == .fBlueThree) {
                    friction[row][column] = 0.6
                } else if (fricPixelBuffer[offset] == .fYllwOne) || (fricPixelBuffer[offset] == .fGreenOne) {
                    friction[row][column] = 1.3
                } else if (fricPixelBuffer[offset] == .fYllwTwo) || (fricPixelBuffer[offset] == .fGreenTwo) {
                    friction[row][column] = 1.6
                } else {
                    friction[row][column] = 0.0
                }
            }
        }
        
        
        return friction
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


