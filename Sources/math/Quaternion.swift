public struct Quat<T: FloatingPoint> {
    var r: T
    var i: Vec3<T>

    var ix: T { get { i[0] } set { i[0] = newValue }}
    var iy: T { get { i[1] } set { i[1] = newValue }}
    var iz: T { get { i[2] } set { i[2] = newValue }}

    var length: T { i.length }
}

extension Quat {
    public init(angle: T, axis: Vec3<T>) {
        self.init(r: angle, i: axis)
    }
    public init(angle: T, axis: [T]) {
        self.init(r: angle, i: Vec3<T>(axis))
    }
}

public typealias QuatF = Quat<Float>
public typealias QuatD = Quat<Double>


//https://github.com/xybp888/iOS-SDKs/blob/master/iPhoneOS13.0.sdk/usr/include/simd/quaternion.h
