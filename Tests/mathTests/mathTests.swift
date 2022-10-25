import XCTest
import simd

@testable import math

final class mathTests: XCTestCase {
    func testVecEquatable() throws {
        let a2 = Vec2F([3,4])
        let b2 = Vec2F([3,4])
        let c2 = Vec2F([1,4])
        let a3 = Vec3F([3,4,0])
        let b3 = Vec3F([3,4,0])
        let c3 = Vec3F([3,4,1])
        XCTAssertEqual(a2==a2, true)
        XCTAssertEqual(a2==b2, true)
        XCTAssertEqual(a2==c2, false)
        XCTAssertEqual(a3==a3, true)
        XCTAssertEqual(a3==b3, true)
        XCTAssertEqual(a3==c3, false)
    }

    func testVecArithmetic() throws {
        let a2 = Vec2F([3,4])
        let b2 = Vec2F([1,4])
        let a3 = Vec3F([3,4,0])
        let b3 = Vec3F([3,4,1])
        XCTAssertEqual(a2+a2 == Vec2F([6,8]), true)
        XCTAssertEqual(a2-b2 == Vec2F([2,0]), true)
        XCTAssertEqual(b2*3 == Vec2F([3,12]), true)
        XCTAssertEqual(3*b2 == Vec2F([3,12]), true)
        XCTAssertEqual(a3+a3 == Vec3F([6,8,0]), true)
        XCTAssertEqual(a3-b3 == Vec3F([0,0,-1]), true)
        XCTAssertEqual(b3*1.5 == Vec3F([4.5, 6, 1.5]), true)
    }

    func testVec2Dot() throws {
        let v = Vec2F([3,4])
        XCTAssertEqual(v.magnitude, 5)
        XCTAssertEqual(v⋅v, 25)
    }

    func testVec3Cross() throws {
        let a = Vec3F([7,6,4])
        let b = Vec3F([2,1,3])
        XCTAssertEqual(a.cross(with:b).array, [14, 13, -5])
    }

    func testVec3CrossUnit() throws {
        let a = Vec3F([1,0,0])
        let b = Vec3F([0,1,0])
        XCTAssertEqual(a.cross(with:b).array, [0, 0, 1])
        XCTAssertEqual((a×b).array, [0, 0, 1])
    }

    func testMat22() throws {
        let a = Mat22D(array: [-2, -1, 3, 3]).inverse()
        XCTAssertEqual(a.array, [-1,-1.0/3.0,1,2.0/3.0])
    }
//    func testHamilton() throws {
////        let i = Vec3F([1,0,0])
////        let j = Vec3F([0,1,0])
////        let k = Vec3F([0,0,1])
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
