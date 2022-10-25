import XCTest
import simd

@testable import math

final class mathTests: XCTestCase {
    func testVecEquatable() throws {
        let a2 = Vec2f(array: [3,4])
        let b2 = Vec2f(array: [3,4])
        let c2 = Vec2f(array: [1,4])
        let a3 = Vec3f(array: [3,4,0])
        let b3 = Vec3f(array: [3,4,0])
        let c3 = Vec3f(array: [3,4,1])
        XCTAssertEqual(a2==a2, true)
        XCTAssertEqual(a2==b2, true)
        XCTAssertEqual(a2==c2, false)
        XCTAssertEqual(a3==a3, true)
        XCTAssertEqual(a3==b3, true)
        XCTAssertEqual(a3==c3, false)
    }

    func testVecArithmetic() throws {
        let a2 = Vec2f(array: [3,4])
        let b2 = Vec2f(array: [1,4])
        let a3 = Vec3f(array: [3,4,0])
        let b3 = Vec3f(array: [3,4,1])
        XCTAssertEqual(a2+a2 == Vec2f(array: [6,8]), true)
        XCTAssertEqual(a2-b2 == Vec2f(array: [2,0]), true)
        XCTAssertEqual(b2*3 == Vec2f(array: [3,12]), true)
        XCTAssertEqual(3*b2 == Vec2f(array: [3,12]), true)
        XCTAssertEqual(a3+a3 == Vec3f(array: [6,8,0]), true)
        XCTAssertEqual(a3-b3 == Vec3f(array: [0,0,-1]), true)
        XCTAssertEqual(b3*1.5 == Vec3f(array: [4.5, 6, 1.5]), true)
    }

    func testVec2Dot() throws {
        let v = Vec2f(array: [3,4])
        XCTAssertEqual(v.magnitude, 5)
        XCTAssertEqual(v⋅v, 25)
    }

    func testVec3Cross() throws {
        let a = Vec3f(array: [7,6,4])
        let b = Vec3f(array: [2,1,3])
        XCTAssertEqual(a.cross(with:b).array, [14, 13, -5])
    }

    func testVec3CrossUnit() throws {
        let a = Vec3f(array: [1,0,0])
        let b = Vec3f(array: [0,1,0])
        XCTAssertEqual(a.cross(with:b).array, [0, 0, 1])
        XCTAssertEqual((a×b).array, [0, 0, 1])
    }

    func testMat22Inverse() throws {
        let a = Mat22d(array: [-2, -1, 3, 3]).inverse()
        XCTAssertEqual(a.array, [-1,-1.0/3.0,1,2.0/3.0])
        let b = Mat22d(array: [-2, -1, 3, 3]) * -1
        XCTAssertEqual(b.array, [2, 1, -3, -3])
    }

    func testMat22Init() throws {
        let a = Vec2f(array: [1,1])
        let b = Vec2f(array: [2,2])
        let mr = Mat22f(rows: [a,b])
        let mc = Mat22f(columns: [a,b])
        XCTAssertEqual(mr.array, [1,1,2,2])
        XCTAssertEqual(mc.array, [1,2,1,2])
        let rows = mr.rows
        let cols = mc.columns
        XCTAssertEqual(rows, [a,b])
        XCTAssertEqual(cols, [a,b])
    }

    func testMat22Mult() throws {
        var a = Mat22d(array: [0, 2, 3, 5])
        let b = Mat22d(array: [0, 1, 2, 5])
        XCTAssertEqual((a * b).array, [4, 10, 10, 28])
        XCTAssertEqual((b * a).array, [3, 5, 15, 29])
        a *= b
        XCTAssertEqual(a.array, [4, 10, 10, 28])
    }

    func testMat33Init() throws {
        let a = Vec3f(array: [1,1,1])
        let b = Vec3f(array: [2,2,2])
        let c = Vec3f(array: [3,3,3])
        let mr = Mat33f(rows: [a,b,c])
        let mc = Mat33f(columns: [a,b,c])
        XCTAssertEqual(mr.array, [1,1,1,2,2,2,3,3,3])
        XCTAssertEqual(mc.array, [1,2,3,1,2,3,1,2,3])
        let rows = mr.rows
        let cols = mc.columns
        XCTAssertEqual(rows, [a,b,c])
        XCTAssertEqual(cols, [a,b,c])
    }

    func testMat33Mult() throws {
        let a = Mat33d(array: [3,-1,0,2,5,1,-7,1,3])
        let b = Mat33d(array: [6,-1,0,0,1,-2,3,-8,1])
        XCTAssertEqual((a * b).array, [18,-4,2,15,-5,-9,-33,-16,1])
        XCTAssertEqual((b * a).array, [16,-11,-1,16,3,-5,-14,-42,-5])
        XCTAssertEqual((b * a * -2).array, [-32,22,2,-32,-6,10,28,84,10])
    }

    func testMat33() throws {
        let a = Mat33d(array: [1, 2, 3, 0, 1, 4, 5, 6, 0]).inverse()
        XCTAssertEqual(a.array, [-24.0, 18.0, 5.0, 20.0, -15.0, -4.0, -5.0, 4.0, 1.0])
    }

//    func testHamilton() throws {
////        let i = Vec3f(array: [1,0,0])
////        let j = Vec3f(array: [0,1,0])
////        let k = Vec3f(array: [0,0,1])
////        XCTAssertEqual((i×j⋅k), -1)
//    }

    func testQuatF() throws {
        let sq = simd_quatf(ix: 3, iy: 4, iz: 5, r: 2)
        let sp = simd_quatf(ix: 7, iy: 8, iz: 9, r: 6)
        let q = QuatF(sq)
        let p = QuatF(sp)
        XCTAssertEqual(q+p == QuatF(sq + sp), true)
        XCTAssertEqual(q-p == QuatF(sq - sp), true)
        XCTAssertEqual(q*p == QuatF(sq * sp), true)

        XCTAssertEqual(q.conjugate().array, [2, -3, -4, -5])
        XCTAssertEqual(q^.array, [2, -3, -4, -5])

        XCTAssertEqual(q.norm(), q^.norm())
        XCTAssertEqual((p*q).norm(), p.norm() * q.norm())

        XCTAssertEqual(q.inverse, QuatF(sq.inverse))
        XCTAssertEqual((q * q.inverse).array.map { round($0) }, [1,0,0,0].map { Float($0) })

    }

    func testQuatConjugate() throws {
    }

    func testQuat() throws {
        let q0 = QuatF(angle: .pi, axis: [-2, 1, 0.5])
        XCTAssertEqual(q0.length, 2.291288)
        let q1 = QuatD(angle: .pi, axis: [-2, 1, 0.5])
        XCTAssertEqual(q1.length, 2.29128784747792)

/*
let originVector = simd_float3(x: 0, y: 0, z: 1)

let quaternion = simd_quatf(angle: degreesToRadians(-60),
                            axis: simd_float3(x: 1,
                                              y: 0,
                                              z: 0))
let rotatedVector = quaternion.act(originVector)
*/
    }

}
