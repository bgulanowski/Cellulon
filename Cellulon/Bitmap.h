//
//  Bitmap.h
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-15.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

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

extern Color ColorForCGColor(CGColorRef color);
extern CGColorRef CGColorForColor(Color color);

@interface Bitmap : NSObject

@property (nonatomic, readonly) CGSize size;

- (instancetype)initWithSize:(CGSize)size color:(Color)color;
- (instancetype)initWithSize:(CGSize)size CGColor:(CGColorRef)color;

- (void)clearWithColor:(Color)color;
- (Color)colorAtPoint:(CGPoint)point;
- (void)setColor:(Color)color atPoint:(CGPoint)point;

- (void)clearWithCGColor:(CGColorRef)color;
- (CGColorRef)CGColorAtPoint:(CGPoint)point;
- (void)setCGColor:(CGColorRef)color atPoint:(CGPoint)point;

@end
