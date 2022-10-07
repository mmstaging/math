import XCTest
@testable import math

final class mathTests: XCTestCase {
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
