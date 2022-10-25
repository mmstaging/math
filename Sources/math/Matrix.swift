public enum MatrixIndex {
    // m x n matrix index: _mn:  m is row-index, n is column-index
    case _00, _01, _02, _03
    case _10, _11, _12, _13
    case _20, _21, _22, _23
    case _30, _31, _32, _33
}

public protocol Matrix<T>: Equatable {
    associatedtype T = Numeric
    init()
    init(array: [T])
    var array: [T] { get }
    subscript(index: MatrixIndex) -> T { get set }
    static func ==(lhs: Self, rhs: Self) -> Bool
    static var zero: Self { get }
    static var identity: Self { get }
}

extension Matrix where T:Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.array == rhs.array
    }
}

extension Matrix {
   public static var zero: Self {
        Self()
    }
}

fileprivate let matrix22IndexToArrayIndex:[MatrixIndex:Int] = [._00: 0, ._01: 1, ._10: 2, ._11: 3]
fileprivate let matrix33IndexToArrayIndex:[MatrixIndex:Int] = [._00: 0, ._01: 1, ._02: 2, ._10: 3, ._11: 4, ._12: 5, ._20: 6, ._21: 7, ._22: 8]
fileprivate let matrix44IndexToArrayIndex:[MatrixIndex:Int] = [._00: 0, ._01: 1, ._02: 2, ._03: 3, ._10: 4, ._11: 5, ._12: 6, ._13: 7, ._20: 8, ._21: 9, ._22: 10, ._23: 11, ._30: 12,._31: 13, ._32: 14, ._33: 15]


public struct Matrix22<T:FloatingPoint>: Matrix {
    let m, n: Int
    var store: [T]

    public init() {
        (m,n) = (2,2)
        store = Array(repeating: 0, count: 4)
    }

    public init(array: [T]) {
        precondition(array.count == 4)
        (m,n) = (2,2)
        store = array
    }

    public init(diagonal: [T]) {
        precondition(diagonal.count == 2)
        (m,n) = (2,2)
        store = Array(repeating: 0, count: 4)
        self[._00] = diagonal[0]
        self[._11] = diagonal[1]
    }


    public var array: [T] {
        store
    }

    public static var identity: Matrix22 {
        Matrix22(diagonal: [1,1])
    }

    public func inverse() -> Matrix22 {
        let det = determinant()
        guard !det.isZero else { fatalError("determinant is zero \(array)") }
        return Matrix22(array: [self[._11], -self[._01], -self[._10], self[._00]].map { $0 / det })
    }

    public func transpose() -> Matrix22 {
        var result = self
        (result[._01], result[._10]) = (result[._10], result[._01])
        return result
    }

    public func determinant() -> T {
        (self[._00] * self[._11]) - (self[._01] * self[._10])
    }

    public var isSymmetric: Bool {
        transpose() == self
    }

    public var isSkewSymmetric: Bool {
        transpose().array.map { $0 * -1 } == array
    }

    public var isDiagonal: Bool {
        self[._01] == 0 && self[._10] == 0
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
        min(self[._00], self[._11]) > 0
    }

    public var isRotation: Bool {
        inverse() == transpose()
    }

    public var diagonal: [T] {
        [self[._00], self[._11]]
    }

    public subscript(index: MatrixIndex) -> T {
        get { store[matrix22IndexToArrayIndex[index]!] }
        set { store[matrix22IndexToArrayIndex[index]!] = newValue }
    }

    public subscript(i:Int, j:Int) -> T {
        get { store[i*4 + j] }
        set { store[i*4 + j] = newValue }
    }
}

public typealias Mat22F = Matrix22<Float>
public typealias Mat22D = Matrix22<Double>
