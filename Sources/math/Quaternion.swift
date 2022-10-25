import simd

public struct Quat<T: FloatingPoint>: Equatable{
    var r: T
    var i: Vec3<T>

    var ix: T { get { i[0] } set { i[0] = newValue }}
    var iy: T { get { i[1] } set { i[1] = newValue }}
    var iz: T { get { i[2] } set { i[2] = newValue }}
    var scalar: T { r }
    var vector: Vec3<T> { i }

    var array: [T] {[r,i[0],i[1],i[2]]}

    var length: T { i.length }
}

extension Quat {
    public init(_ arr:[T]) {
        self.init(r: arr[0], i: Vec3<T>(Array(arr[1...])))
    }
}

extension Quat where T == Float {
    public init(_ q: simd_quatf) {
        r = q.real
        i = Vec3([q.imag[0], q.imag[1], q.imag[2]])
    }
}

extension Quat where T == Double {
    public init(_ q: simd_quatd) {
        r = q.real
        i = Vec3([q.imag[0], q.imag[1], q.imag[2]])
    }
}

extension Quat {
    public init(angle: T, axis: Vec3<T>) { // FIX THIS!!!!
        self.init(r: angle, i: axis)
    }
    public init(angle: T, axis: [T]) {
        self.init(r: angle, i: Vec3<T>(axis))
    }
}

//MARK: Quaternion arithmetic

infix operator +: AdditionPrecedence
infix operator -: AdditionPrecedence
infix operator +=: AssignmentPrecedence
infix operator -=: AssignmentPrecedence

extension Quat {
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
        Self(lhs.array.map { $0 * rhs })
    }
}

//MARK: Quaternion Multiplication
//infix operator *

extension Quat where T == Float {
    public static func *(lhs: Self, rhs: Self) -> Self {
        let q0 = lhs.array
        let q1 = rhs.array
        let (w0,x0,y0,z0) = (q0[0], q0[1], q0[2], q0[3])
        let (w1,x1,y1,z1) = (q1[0], q1[1], q1[2], q1[3])
        return QuatF([
            w0*w1 - x0*x1 - y0*y1 - z0*z1,
            w0*x1 + x0*w1 + y0*z1 - z0*y1,
            w0*y1 - x0*z1 + y0*w1 + z0*x1,
            w0*z1 + x0*y1 - y0*x1 + z0*w1
        ])
    }
}

extension Quat where T == Double {
    public static func *(lhs: Self, rhs: Self) -> Self {
        let q0 = lhs.array
        let q1 = rhs.array
        let (w0,x0,y0,z0) = (q0[0], q0[1], q0[2], q0[3])
        let (w1,x1,y1,z1) = (q1[0], q1[1], q1[2], q1[3])
        return QuatD([
            w0*w1 - x0*x1 - y0*y1 - z0*z1,
            w0*x1 + x0*w1 + y0*z1 - z0*y1,
            w0*y1 - x0*z1 + y0*w1 + z0*x1,
            w0*z1 + x0*y1 - y0*x1 + z0*w1
        ])
    }
}

postfix operator ^

extension Quat {
    public func conjugate() -> Self {
        Self.init(r: r, i:i * -1)
    }

    public static postfix func ^(rhs: Self) -> Quat<T> {
        rhs.conjugate()
    }

    public func norm() -> T {
        array.reduce(0) { $0 + $1 * $1 }
    }

    public var inverse: Self {
        conjugate() * (T(1) / norm())
    }
}

infix operator ⋅: MultiplicationPrecedence
extension Quat {
    public func dot(with other: Self) -> T {
        r*other.r + i.dot(with: other.i)
    }
    public static func ⋅(lhs: Self, rhs: Self) -> T {
        lhs.dot(with: rhs)
    }
}

public func toMatrix() {
}

//infix operator *: MultiplicationPrecedence
//extension Quat {
//    func *(lhs: Quat<T>, rhs: Quat<T>) {
//
//    }
//}

public typealias QuatF = Quat<Float>
public typealias QuatD = Quat<Double>


//https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS13.0.sdk/usr/include/simd/quaternion.h
