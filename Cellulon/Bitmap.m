//
//  Bitmap.m
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-15.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

#import "Bitmap.h"

Color ColorForCGColor(CGColorRef color) {
    Color r;
    r.v = 0;
    return r;
}

CGColorRef CGColorForColor(Color color) {
    
    CGColorRef r = CGColorCreate(NULL, NULL);
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
    return [self initWithSize:size color:ColorForCGColor(color)];
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
    [self clearWithColor:ColorForCGColor(color)];
}

- (CGColorRef)CGColorAtPoint:(CGPoint)point
{
    return CGColorForColor([self colorAtPoint:point]);
}

- (void)setCGColor:(CGColorRef)color atPoint:(CGPoint)point
{
    [self setColor:ColorForCGColor(color) atPoint:point];
}

@end
