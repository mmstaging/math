//MARK: - Type Aliases
public typealias Mat22f = Matrix22<Float>
public typealias Mat22d = Matrix22<Double>
public typealias Mat33f = Matrix33<Float>
public typealias Mat33d = Matrix33<Double>
public typealias MatH44f = MatrixH44<Float>
public typealias MatH44d = MatrixH44<Double>

//MARK: - MatrixIndex
public enum MatrixIndex {
    // m x n matrix index: _mn:  m is row-index, n is column-index
    case _00, _01, _02, _03
    case _10, _11, _12, _13
    case _20, _21, _22, _23
    case _30, _31, _32, _33
}

fileprivate let matrix22IndexToArrayIndex:[MatrixIndex:Int] = [._00: 0, ._01: 1, ._10: 2, ._11: 3]
fileprivate let matrix33IndexToArrayIndex:[MatrixIndex:Int] = [._00: 0, ._01: 1, ._02: 2, ._10: 3, ._11: 4, ._12: 5, ._20: 6, ._21: 7, ._22: 8]
fileprivate let matrixH44IndexToArrayIndex:[MatrixIndex:Int] = [._00: 0, ._01: 1, ._02: 2, ._03: 3, ._10: 4, ._11: 5, ._12: 6, ._13: 7, ._20: 8, ._21: 9, ._22: 10, ._23: 11, ._30: 12,._31: 13, ._32: 14, ._33: 15]

//MARK: - Matrix protocol
public protocol Matrix<T>: Equatable {
    associatedtype T = Numeric
    subscript(index: MatrixIndex) -> T { get set }
}

//MARK: - SquareMatrix protocol
public protocol SquareMatrix<T>: Matrix {
    associatedtype T = Numeric
    init()
    init(array: [T])
    var array: [T] { get }
    static func ==(lhs: Self, rhs: Self) -> Bool
    static func *(lhs: Self, rhs: Self) -> Self

    static var zero: Self { get }
    static var identity: Self { get }
    func determinant() -> T
    func inverse() -> Self
    func transpose() -> Self
    var diagonal: [T] { get }
    var isDiagonal: Bool { get }
}

extension SquareMatrix where T:Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.array == rhs.array
    }
}

extension SquareMatrix where T:FloatingPoint {
    public static var zero: Self {
        Self()
    }

    public var isZero: Bool {
        array.filter { $0 != 0 }.isEmpty
    }

    public var isIdentity: Bool {
        isDiagonal && diagonal.filter { $0 != 1 }.isEmpty
    }

    public var isSymmetric: Bool {
        transpose() == self
    }

    public var isSkewSymmetric: Bool {
        transpose().array.map { $0 * -1 } == array
    }

    public var isOrthonormal: Bool {
        inverse() == transpose() && abs(determinant()) == 1
    }

    public var isRightHanded: Bool {
        isOrthonormal && determinant() == 1
    }

    public var isLeftHanded: Bool {
        isOrthonormal && determinant() == -1
    }

    public var isScaling: Bool {
        isDiagonal && diagonal.min()! > 0
    }

    public var isRotation: Bool {
        inverse() == transpose()
    }
}

extension SquareMatrix where T: Numeric {
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
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
}


//MARK: - Matrix22
public struct Matrix22<T:FloatingPoint>: SquareMatrix {
    var store: [T]

    public init() {
        store = Array(repeating: 0, count: 4)
    }

    public init(array: [T]) {
        precondition(array.count == 4)
        store = array
    }

    public init(rows: [Vec2<T>]) {
        precondition(rows.count == 2)
        self.init(array: rows.flatMap { $0.array })
    }

    public init(columns: [Vec2<T>]) {
        precondition(columns.count == 2)
        self = Self(array: columns.flatMap { $0.array }).transpose()
    }

    public init(diagonal: [T]) {
        precondition(diagonal.count == 2)
        store = Array(repeating: 0, count: 4)
        self[._00] = diagonal[0]
        self[._11] = diagonal[1]
    }

    public var array: [T] {
        store
    }

    public var rows: [Vec2<T>] {
        [Vec2(array: [self[._00], self[._01]]), Vec2(array: [self[._10], self[._11]])]
    }

    public var columns: [Vec2<T>] {
        [Vec2(array: [self[._00], self[._10]]), Vec2(array: [self[._01], self[._11]])]
    }

    public static var identity: Self {
        .init(diagonal: [1,1])
    }

    public func inverse() -> Self {
        let det = determinant()
        guard !det.isZero else { fatalError("determinant is zero \(array)") }
        return .init(array: [self[._11], -self[._01], -self[._10], self[._00]].map { $0 / det })
    }

    public func transpose() -> Self {
        var result = self
        (result[._01], result[._10]) = (result[._10], result[._01])
        return result
    }

    public func determinant() -> T {
        (self[._00] * self[._11]) - (self[._01] * self[._10])
    }

    public var isDiagonal: Bool {
        self[._01] == 0 && self[._10] == 0
    }

    public var diagonal: [T] {
        [self[._00], self[._11]]
    }

    public subscript(index: MatrixIndex) -> T {
        get { store[matrix22IndexToArrayIndex[index]!] }
        set { store[matrix22IndexToArrayIndex[index]!] = newValue }
    }

    public static func *(lhs: Self, rhs: Self) -> Self {
        let a = lhs[._00] * rhs[._00] + lhs[._01] * rhs[._10]
        let b = lhs[._00] * rhs[._01] + lhs[._01] * rhs[._11]
        let c = lhs[._10] * rhs[._00] + lhs[._11] * rhs[._10]
        let d = lhs[._10] * rhs[._01] + lhs[._11] * rhs[._11]
        return .init(array: [a,b,c,d])
    }
}

//MARK: - Matrix33

public struct Matrix33<T:FloatingPoint>: SquareMatrix {
    var store: [T]

    public init() {
        store = Array(repeating: 0, count: 9)
    }

    public init(array: [T]) {
        precondition(array.count == 9)
        store = array
    }

    public init(rows: [Vec3<T>]) {
        precondition(rows.count == 3)
        self.init(array: rows.flatMap { $0.array })
    }

    public init(columns: [Vec3<T>]) {
        precondition(columns.count == 3)
        self = Self(array: columns.flatMap { $0.array }).transpose()
    }

    public init(diagonal: [T]) {
        precondition(diagonal.count == 3)
        store = Array(repeating: 0, count: 9)
        self[._00] = diagonal[0]
        self[._11] = diagonal[1]
        self[._22] = diagonal[2]
    }

    public var array: [T] {
        store
    }

    public var rows: [Vec3<T>] {
        [   Vec3(array: [self[._00], self[._01], self[._02]]),
            Vec3(array: [self[._10], self[._11], self[._12]]),
            Vec3(array: [self[._20], self[._21], self[._22]])]
    }

    public var columns: [Vec3<T>] {
        [   Vec3(array: [self[._00], self[._10], self[._20]]),
            Vec3(array: [self[._01], self[._11], self[._21]]),
            Vec3(array: [self[._02], self[._12], self[._22]])]
    }

    public static var identity: Self {
        .init(diagonal: [1,1,1])
    }

    public func adjugate() -> Self {
        let d00 = self[._11] * self[._22] - self[._12] * self[._21]
        let d01 = self[._10] * self[._22] - self[._12] * self[._20]
        let d02 = self[._10] * self[._21] - self[._11] * self[._20]
        let d10 = self[._01] * self[._22] - self[._02] * self[._21]
        let d11 = self[._00] * self[._22] - self[._02] * self[._20]
        let d12 = self[._00] * self[._21] - self[._01] * self[._20]
        let d20 = self[._01] * self[._12] - self[._02] * self[._11]
        let d21 = self[._00] * self[._12] - self[._02] * self[._10]
        let d22 = self[._00] * self[._11] - self[._01] * self[._10]
        return Self(array: [d00, -d01, d02, -d10, d11, -d12, d20, -d21, d22])
    }

    public func inverse() -> Self {
        let det = determinant()
        guard !det.isZero else { fatalError("determinant is zero \(array)") }
        return Self(array: transpose().adjugate().array.map { $0 / det })
    }

    public func transpose() -> Self {
        var result = self
        (result[._01], result[._10]) = (result[._10], result[._01])
        (result[._02], result[._20]) = (result[._20], result[._02])
        (result[._21], result[._12]) = (result[._12], result[._21])
        return result
    }

    public func determinant() -> T {
        let detA = (self[._11] * self[._22]) - (self[._12] * self[._21])
        let detB = (self[._10] * self[._22]) - (self[._12] * self[._20])
        let detC = (self[._10] * self[._21]) - (self[._11] * self[._20])
        return self[._00] * detA - self[._01] * detB + self[._02] * detC
    }

    public var isDiagonal: Bool {
        self[._01] == 0 && self[._02] == 0 && self[._10] == 0 && self[._12] == 0 && self[._20] == 0 && self[._21] == 0
    }

    public var diagonal: [T] {
        [self[._00], self[._11], self[._22]]
    }

    public subscript(index: MatrixIndex) -> T {
        get { store[matrix33IndexToArrayIndex[index]!] }
        set { store[matrix33IndexToArrayIndex[index]!] = newValue }
    }

    public static func *(lhs: Self, rhs: Self) -> Self {
        let a = lhs[._00] * rhs[._00] + lhs[._01] * rhs[._10] + lhs[._02] * rhs[._20]
        let b = lhs[._00] * rhs[._01] + lhs[._01] * rhs[._11] + lhs[._02] * rhs[._21]
        let c = lhs[._00] * rhs[._02] + lhs[._01] * rhs[._12] + lhs[._02] * rhs[._22]
        let d = lhs[._10] * rhs[._00] + lhs[._11] * rhs[._10] + lhs[._12] * rhs[._20]
        let e = lhs[._10] * rhs[._01] + lhs[._11] * rhs[._11] + lhs[._12] * rhs[._21]
        let f = lhs[._10] * rhs[._02] + lhs[._11] * rhs[._12] + lhs[._12] * rhs[._22]
        let g = lhs[._20] * rhs[._00] + lhs[._21] * rhs[._10] + lhs[._22] * rhs[._20]
        let h = lhs[._20] * rhs[._01] + lhs[._21] * rhs[._11] + lhs[._22] * rhs[._21]
        let i = lhs[._20] * rhs[._02] + lhs[._21] * rhs[._12] + lhs[._22] * rhs[._22]
        return .init(array: [a,b,c,d,e,f,g,h,i])
    }
}



//MARK: - MatrixH44

public struct MatrixH44<T:FloatingPoint>: Matrix {
    var store: [T]

    public init() {
        store = Array(repeating: 0, count: 16)
    }

    public var array: [T] {
        store
    }

    public subscript(index: MatrixIndex) -> T {
        get { store[matrixH44IndexToArrayIndex[index]!] }
        set { store[matrixH44IndexToArrayIndex[index]!] = newValue }
    }
}
