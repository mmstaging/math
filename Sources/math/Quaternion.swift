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
    public init(array:[T]) {
        self.init(r: array[0], i: Vec3(array: Array(array[1...])))
    }
}

extension Quat where T == Float {
    public init(_ q: simd_quatf) {
        r = q.real
        i = Vec3(array: [q.imag[0], q.imag[1], q.imag[2]])
    }
}

extension Quat where T == Double {
    public init(_ q: simd_quatd) {
        r = q.real
        i = Vec3(array: [q.imag[0], q.imag[1], q.imag[2]])
    }
}

extension Quat {
    public init(angle: T, axis: Vec3<T>) { // FIX THIS!!!!
        self.init(r: angle, i: axis)
    }
    public init(angle: T, axis: [T]) {
        self.init(r: angle, i: Vec3(array: axis))
    }
}

//MARK: Quaternion arithmetic

infix operator +: AdditionPrecedence
infix operator -: AdditionPrecedence
infix operator +=: AssignmentPrecedence
infix operator -=: AssignmentPrecedence

extension Quat {
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
        Self(array: lhs.array.map { $0 * rhs })
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
        return QuatF(array: [
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
        return QuatD(array: [
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
quat = [0.7071 0.7071 0 0];
rotm = quat2rotm(quat)
rotm = 3×3

    1.0000         0         0
         0   -0.0000   -1.0000
         0    1.0000   -0.0000
https://www.mathworks.com/help/robotics/ref/quat2rotm.html

 better solution is found by writing out the basis vectors a,b,c and plugging these into the matrix-to-quaternion conversion, where the elements are explicit.

m[0][0] = a.x, m[1][0] = b.x, m[2][0] = c.x
m[0][1] = a.y, m[1][1] = b.y, m[2][1] = c.y
m[0][2] = a.z, m[1][2] = b.z, m[2][2] = c.z
Now, we rewrite the matrix-to-quaternion function using the subsituted orthonormal vectors a,b,c. The result is the following function:

// Quaternion from orthogonal basis
Quaternion& Quaternion::fromBasis(Vector3DF a, Vector3DF b, Vector3DF c)
{
    float T = a.x + b.y + c.z;
    float s;
    if (T > 0) {
        float s = sqrt(T + 1) * 2.f;
        X = (c.y - b.z) / s;
        Y = (a.z - c.x) / s;
        Z = (b.x - a.y) / s;
        W = 0.25f * s;
    } else if ( a.x > b.y && a.x > c.z) {
        s = sqrt(1 + a.x - b.y - c.z) * 2;
        X = 0.25f * s;
        Y = (b.x + a.y) / s;
        Z = (a.z + c.x) / s;
        W = (c.y - b.z) / s;
    } else if (b.y > c.z) {
        s = sqrt(1 + b.y - a.x - c.z) * 2;
        X = (b.x + a.y) / s;
        Y = 0.25f * s;
        Z = (c.y + b.z) / s;
        W = (b.z - c.y) / s;
    } else {
        s = sqrt(1 + c.z - a.x - b.y) * 2;
        X = (a.z + c.x) / s;
        Y = (c.y + b.z) / s;
        Z = 0.25f * s;
        W = (b.x - a.y) / s;
    }
    return *this;
}

Then the matrix can be converted to a quaternion using this basic form:

qw= √(1 + m00 + m11 + m22) /2
qx = (m21 - m12)/( 4 *qw)
qy = (m02 - m20)/( 4 *qw)
qz = (m10 - m01)/( 4 *qw)
