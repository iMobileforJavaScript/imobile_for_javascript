//
//  ColorHSB.m
//  Supermap
//
//  Created by wnmng on 2020/1/17.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "ColorHSB.h"
#import "SuperMap/Color.h"

@interface ColorHSB(){
    float _h;
    float _s;
    float _v;
} 

@end

@implementation ColorHSB


-(id)initWithH:(float)h s:(float)s b:(float)b{
    if (self = [super init]) {
        [self setHue:h];
        [self setSaturation:s];
        [self setBrightness:b];
    }
    return self;
}

-(id)initWithColor:(Color*)rgb{
    if (self = [super init]) {
        double r = ((double)rgb.red / 255.0);
        double g = ((double)rgb.green / 255.0);
        double b = ((double)rgb.blue / 255.0);
        
        double max = MAX(r, MAX(g, b));
        double min = MIN(r, MIN(g, b));
        
        float hue = 0.0;
        if (max == r && g >= b)
        {
            if (max - min == 0) hue = 0.0;
            else hue = 60 * (g - b) / (max - min);
        }
        else if (max == r && g < b)
        {
            hue = 60 * (g - b) / (max - min) + 360;
        }
        else if (max == g)
        {
            hue = 60 * (b - r) / (max - min) + 120;
        }
        else if (max == b)
        {
            hue = 60 * (r - g) / (max - min) + 240;
        }
        
        float sat = (max == 0) ? 0.0 : (1.0 - ((double)min / (double)max));
        float bri = max;
        _h = hue;
        _s = sat;
        _v = bri;
    }
    return self;
}

-(Color*)toColor{
    double r = 0;
    double g = 0;
    double b = 0;
    double hue = _h;
    double sat = _s;
    double bri = _v;
    if (sat == 0)
    {
        r = g = b = bri;
    }
    else
    {
        // the color wheel consists of 6 sectors. Figure out which sector you're in.
        double sectorPos = hue / 60.0;
        int sectorNumber = floor(sectorPos);
        // get the fractional part of the sector
        double fractionalSector = sectorPos - sectorNumber;
        
        // calculate values for the three axes of the color.
        double p = bri * (1.0 - sat);
        double q = bri * (1.0 - (sat * fractionalSector));
        double t = bri * (1.0 - (sat * (1 - fractionalSector)));
        
        // assign the fractional colors to r, g, and b based on the sector the angle is in.
        switch (sectorNumber)
        {
            case 0:
                r = bri;
                g = t;
                b = p;
                break;
            case 1:
                r = q;
                g = bri;
                b = p;
                break;
            case 2:
                r = p;
                g = bri;
                b = t;
                break;
            case 3:
                r = p;
                g = q;
                b = bri;
                break;
            case 4:
                r = t;
                g = p;
                b = bri;
                break;
            case 5:
                r = bri;
                g = p;
                b = q;
                break;
        }
    }
    int red = r * 255;
    int green = g * 255;
    int blue = b * 255; ;
    return [[Color alloc]initWithR:red G:green B:blue];
}

-(float)hue{
    return _h;
}
-(float)saturation{
    return _s;
}
-(float)brightness{
    return _v;
}
-(void)setHue:(float)hue{
    while (hue<0) {
        hue += 360;
    }
    while (hue>360) {
        hue -= 360;
    }
    _h = hue;
}
-(void)setSaturation:(float)value{
    while (value<0) {
        value+=1;
    }
    while (value>1) {
        value-=1;
    }
    _s = value;
}
-(void)setBrightness:(float)value{
    while (value<0) {
        value+=1;
    }
    while (value>1) {
        value-=1;
    }
    _v = value;
}

@end
