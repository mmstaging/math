public struct Vec3<T>: Vec {
    public var x: T
    public var y: T
    public var z: T

    public var array: [T] {[x,y,z]}

    public subscript(index: Int) -> T {
        get { [0: x, 1: y, 2: z][index]!}
        set {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default:
                fatalError("Invalid Vec2 index to set \(index)")
            }
        }
    }
}

extension Vec3 {
    public init(_ arr: [T]) {
        self.init(x: arr[0], y: arr[1], z: arr[2])
    }
}

infix operator ×: MultiplicationPrecedence
extension Vec3 where T: Numeric {
    public func cross(with other: Vec3<T>) -> Vec3<T> {
        Vec3<T>([
            self.y*other.z - self.z*other.y,
            self.x*other.z - self.z*other.x,
            self.x*other.y - self.y*other.x
            ])
    }

    public static func ×(lhs: Vec3<T>, rhs: Vec3<T>) -> Vec3<T> {
        lhs.cross(with: rhs)
    }
}

public typealias Vec3F = Vec3<Float>
public typealias Vec3D = Vec3<Double>

