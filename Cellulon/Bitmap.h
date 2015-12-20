//
//  Bitmap.h
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-15.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    UInt8 r;
    UInt8 g;
    UInt8 b;
    UInt8 a;
} Components;

typedef union {
    UInt32 v;
    Components c;
} Color;

extern Color ColorFromCGColor(CGColorRef color);
extern CGColorRef ColorToCGColor(Color color);

@interface Bitmap : NSObject

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGContextRef graphicsContext;

- (instancetype)initWithSize:(CGSize)size color:(Color)color;
- (instancetype)initWithSize:(CGSize)size CGColor:(CGColorRef)color;

- (void)clearWithColor:(Color)color;
- (Color)colorAtPoint:(CGPoint)point;
- (void)setColor:(Color)color atPoint:(CGPoint)point;

- (void)clearWithCGColor:(CGColorRef)color;
- (CGColorRef)CGColorAtPoint:(CGPoint)point;
- (void)setCGColor:(CGColorRef)color atPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
