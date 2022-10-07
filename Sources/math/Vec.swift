public protocol Vec<T> {
    associatedtype T = Numeric
    init(_ arr: [T])
    var array: [T] { get }
    subscript(index: Int) -> T { get set }
}

infix operator ⋅: MultiplicationPrecedence
extension Vec where T: Numeric {
    public static func ⋅(lhs: Self, rhs: Self) -> T {
        lhs.dot(with: rhs)
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

