import Foundation
import CoreGraphics

struct WorldTransform: Equatable, Codable {
    var origin: CGPoint
    var scale: CGFloat
    var canvasSize: CGSize

    func worldToScreen(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: (point.x - origin.x) * scale + canvasSize.width / 2,
            y: (origin.y - point.y) * scale + canvasSize.height / 2
        )
    }

    func screenToWorld(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: (point.x - canvasSize.width / 2) / scale + origin.x,
            y: origin.y - (point.y - canvasSize.height / 2) / scale
        )
    }

    func worldToScreen(size: CGSize) -> CGSize {
        CGSize(width: size.width * scale, height: size.height * scale)
    }
}
