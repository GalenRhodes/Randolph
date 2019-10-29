//
//  RandolphTests.m
//  RandolphTests
//
//  Created by Galen Rhodes on 2019-06-09.
//  Copyright © 2019 ProjectGalen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <Randolph/PGTools.h>

@interface RandolphTests : XCTestCase
@end

@implementation RandolphTests

    -(void)setUp {
    }

    -(void)tearDown {
    }

    -(void)testEllipseEquations {
        NSSize ellipseSize = NSMakeSize(10.0, 5.0);

        for(int i = 0; i < 360; i+=10) {
            NSPoint ellipsePoint = PGGetPointOnEllipse(&ellipseSize, (M_PI_180 * ((double)i)));
            PGLog(@"Angle: %3d° = (%1.5lf, %1.5lf)", i, ellipsePoint.x, ellipsePoint.y);
        }
    }

    -(void)t2estPerformanceExample {
        [self measureBlock:^{}];
    }

@end
