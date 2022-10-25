public typealias Vec2f = Vec2<Float>
public typealias Vec2d = Vec2<Double>
public typealias Vec3f = Vec3<Float>
public typealias Vec3d = Vec3<Double>

//MARK: - Vector protocol

public protocol Vector<T>: Equatable {
    associatedtype T = Numeric
    init(array: [T])
    var array: [T] { get }
    subscript(index: Int) -> T { get set }
    static func ==(lhs: Self, rhs: Self) -> Bool
}

extension Vector where T:Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.array == rhs.array
    }
}

infix operator ⋅: MultiplicationPrecedence
extension Vector where T: Numeric {
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

extension Vector where T: Numeric {
    public static func +(lhs: Self, rhs: Self) -> Self {
        Self.init(array: zip(lhs.array,rhs.array).map { $0.0 + $0.1 })
    }
    public static func -(lhs: Self, rhs: Self) -> Self {
        Self.init(array: zip(lhs.array,rhs.array).map { $0.0 - $0.1 })
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    public static func *(lhs: Self, rhs: T) -> Self {
        Self.init(array: lhs.array.map{ $0 * rhs })
    }
    public static func *(lhs: T, rhs: Self) -> Self {
        Self.init(array: rhs.array.map{ $0 * lhs })
    }
    public static func *=(lhs: inout Self, rhs: T) {
        lhs = Self.init(array: lhs.array.map{ $0 * rhs })
    }
}

extension Vector where T: FloatingPoint {
    public static func /(lhs: Self, rhs: T) -> Self {
        Self.init(array: lhs.array.map{ $0 / rhs })
    }
    public static func /=(lhs: inout Self, rhs: T) {
        lhs = Self.init(array: lhs.array.map{ $0 / rhs })
    }
}

extension Vector where T: Numeric {
    public func dot(with other: Self) -> T {
        zip(self.array, other.array).reduce(0) { $0 + $1.0 * $1.1 }
    }

   public var magnitudeSquared: T { self.dot(with: self) }
}

extension Vector where T: FloatingPoint {
    public var magnitude: T  {
        self.magnitudeSquared.squareRoot()
    }
    public var length: T  {
        self.magnitudeSquared.squareRoot()
    }
}

// MARK: - Vec2

public struct Vec2<T:Numeric>:Vector  {
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
    public init(array: [T]) {
        precondition(array.count == 2)
        self.init(x: array[0], y: array[1])
    }
}

//MARK: - Vec3

public struct Vec3<T:Numeric>: Vector {
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
    public init(array: [T]) {
        precondition(array.count == 3)
        self.init(x: array[0], y: array[1], z: array[2])
    }
}

infix operator ×: MultiplicationPrecedence
extension Vec3 where T: Numeric {
    public func cross(with other: Vec3<T>) -> Vec3<T> {
        .init(array: [y*other.z - z*other.y, x*other.z - z*other.x, x*other.y - y*other.x])
    }

    public static func ×(lhs: Vec3<T>, rhs: Vec3<T>) -> Vec3<T> {
        lhs.cross(with: rhs)
    }
}

