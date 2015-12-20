//
//  Bitmap.m
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-15.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

#import "Bitmap.h"

static CGColorSpaceRef rgbColorSpace;

/*
 * let Q = 1.0/256.0
 *
 * 0x00 <->   0 <->  0.0 ..<    Q
 * 0x01 <->   1 <->   1Q ..<   2Q
 * 0xFE <-> 254 <-> 254Q ..< 255Q
 * 0xFF <-> 255 <-> 255Q ...  Inf(256Q) ???
 *
 * 0x00       ->   0Q (0.0)
 * 0x01       ->   1Q (~0.0039)
 * 0x8F (127) -> 128Q (0.5)
 * 0xFF (255) -> 256Q (1.0)
 */

static const CGFloat Q = 1.0/256.0f;

inline static UInt8 FloatToByte(CGFloat f) {
    if (f >= 1.0) {
        return (UInt8)255;
    }
    else {
        return f < Q ? 0 : (UInt8)(f * 256.0 - 1.0);
    }
}

Color ColorFromCGColor(CGColorRef color) {
    Color r;
    const CGFloat *components = CGColorGetComponents(color);
    if (CGColorGetNumberOfComponents(color) == 4) {
        r.c.r = FloatToByte(components[0]);
        r.c.g = FloatToByte(components[1]);
        r.c.b = FloatToByte(components[2]);
        r.c.a = FloatToByte(components[3]);
    }
    else {
        r.c.r = r.c.g = r.c.b = FloatToByte(components[0]);
        r.c.a = FloatToByte(components[1]);
    }
    return r;
}

CGColorRef ColorToCGColor(Color color) {
    
    CGFloat components[4];
    components[0] = ((CGFloat)color.c.r + 1.0) / 256.0;
    components[1] = ((CGFloat)color.c.g + 1.0) / 256.0;
    components[2] = ((CGFloat)color.c.b + 1.0) / 256.0;
    components[3] = ((CGFloat)color.c.a + 1.0) / 256.0;
    CGColorRef r = CGColorCreate(rgbColorSpace, components);
    return r;
}

static inline NSUInteger OffsetForPoint(CGPoint point, CGFloat w) {
    return (NSUInteger)(point.y * w + point.x);
}

@implementation Bitmap {
    CGSize _size;
    UInt32 *_bits;
    CGContextRef _context;
}

+ (void)load
{
    rgbColorSpace = CGColorSpaceCreateDeviceRGB();
}

- (instancetype)initWithSize:(CGSize)size color:(Color)color
{
    self = [super init];
    if (self) {
        _size = size;
        _bits = malloc(sizeof(UInt32) * size.height * size.width);
        _context = CGBitmapContextCreate(_bits, (size_t)size.width, (size_t)size.height, 8, size.width * 4, NULL, kCGImageAlphaPremultipliedLast);
        [self clearWithColor:color];
    }
    return self;
}

- (CGContextRef)graphicsContext
{
    return _context;
}

- (instancetype)initWithSize:(CGSize)size CGColor:(CGColorRef)color
{
    return [self initWithSize:size color:ColorFromCGColor(color)];
}

- (void)clearWithColor:(Color)color
{
    for (NSUInteger i = 0; i < (NSUInteger)(_size.width * _size.height); ++i) {
        _bits[i] = color.v;
    }
}

- (Color)colorAtPoint:(CGPoint)point
{
    Color c;
    c.v = _bits[OffsetForPoint(point, _size.width)];
    return c;
}

- (void)setColor:(Color)color atPoint:(CGPoint)point
{
    _bits[OffsetForPoint(point, _size.width)] = color.v;
}

- (void)clearWithCGColor:(CGColorRef)color
{
    [self clearWithColor:ColorFromCGColor(color)];
}

- (CGColorRef)CGColorAtPoint:(CGPoint)point
{
    return ColorToCGColor([self colorAtPoint:point]);
}

- (void)setCGColor:(CGColorRef)color atPoint:(CGPoint)point
{
    [self setColor:ColorFromCGColor(color) atPoint:point];
}

@end
