public protocol Vec<T>: Equatable {
    associatedtype T = Numeric
    init(_ arr: [T])
    var array: [T] { get }
    subscript(index: Int) -> T { get set }
    static func ==(lhs: Self, rhs: Self) -> Bool
}

extension Vec where T:Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.array == rhs.array
    }
}

infix operator ⋅: MultiplicationPrecedence
extension Vec where T: Numeric {
    public static func ⋅(lhs: Self, rhs: Self) -> T {
        lhs.dot(with: rhs)
    }
}

//MARK: - Scalar Arithmetic

infix operator +: AdditionPrecedence
infix operator -: AdditionPrecedence
infix operator +=: AssignmentPrecedence
infix operator -=: AssignmentPrecedence
infix operator *: MultiplicationPrecedence
infix operator *=: AssignmentPrecedence
infix operator /: MultiplicationPrecedence
infix operator /=: AssignmentPrecedence

extension Vec where T: Numeric {
    public static func +(lhs: Self, rhs: Self) -> Self {
        Self.init(zip(lhs.array,rhs.array).map { $0.0 + $0.1 })
    }
    public static func -(lhs: Self, rhs: Self) -> Self {
        Self.init(zip(lhs.array,rhs.array).map { $0.0 - $0.1 })
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    public static func *(lhs: Self, rhs: T) -> Self {
        Self.init(lhs.array.map{ $0 * rhs })
    }
    public static func *(lhs: T, rhs: Self) -> Self {
        Self.init(rhs.array.map{ $0 * lhs })
    }
    public static func *=(lhs: inout Self, rhs: T) {
        lhs = Self.init(lhs.array.map{ $0 * rhs })
    }
}

extension Vec where T: FloatingPoint {
    public static func /(lhs: Self, rhs: T) -> Self {
        Self.init(lhs.array.map{ $0 / rhs })
    }
    public static func /=(lhs: inout Self, rhs: T) {
        lhs = Self.init(lhs.array.map{ $0 / rhs })
    }
}

extension Vec where T: Numeric {
    public func dot(with other: Self) -> T {
        zip(self.array, other.array).reduce(T(exactly: 0)!) { $0 + $1.0 * $1.1 }
    }

   public var magnitudeSquared: T { self.dot(with: self) }
}

extension Vec where T: FloatingPoint {
    public var magnitude: T  {
        self.magnitudeSquared.squareRoot()
    }
    public var length: T  {
        self.magnitudeSquared.squareRoot()
    }
}

// MARK: - Vec2

public struct Vec2<T:Numeric>:Vec  {
    public var x: T
    public var y: T
    public var array: [T] {[x,y]}
    public var xy : [T] { array }
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


//MARK: - Vec3

public struct Vec3<T:Numeric>: Vec {
    public var x: T
    public var y: T
    public var z: T

    public var array: [T] {[x,y,z]}
    public var xyz: [T] { array }

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


