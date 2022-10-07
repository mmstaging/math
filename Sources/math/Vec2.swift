public struct Vec2<T>:Vec  {
    public var x: T
    public var y: T
    public var array: [T] {[x,y]}
    public subscript(index: Int) -> T {
        get { [0: x, 1: y][index]! }
        set {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            default: fatalError("Invalid Vec2 index to set \(index)")
            }
        }
    }
}

extension Vec2 {
    public init(_ arr: [T]) {
        self.init(x: arr[0], y: arr[1])
    }
}

public typealias Vec2F = Vec2<Float>
public typealias Vec2D = Vec2<Double>

