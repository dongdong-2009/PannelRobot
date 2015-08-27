#ifndef ICDATATYPE_H
#define ICDATATYPE_H

struct ICRange
{
    ICRange():min(0),max(0),decimal(0){}
    ICRange(double min, double max, int decimal):min(min),max(max),decimal(decimal){}
    double min;
    double max;
    int decimal;
};

#endif // ICDATATYPE_H
