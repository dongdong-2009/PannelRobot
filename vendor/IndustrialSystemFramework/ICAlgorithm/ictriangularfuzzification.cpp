#include "ictriangularfuzzification.h"


static double LeftBoundTriangularProportion(double min, double max, double var)
{
    double diff = max - min;
    double middle = min + (diff / 2);
    if(var < min)
    {
        return 1;
    }
    else if(var >= min && var < middle)
    {
        return (var - min) / (middle - min);
    }
    else if(var >= middle && var < max)
    {
        return (max - var ) / (max - middle);
    }
    else
    {
        return 0;
    }
}

static double RightBoundTriangularProportion(double min, double max, double var)
{
    double diff = max - min;
    double middle = min + (diff / 2);
    if(var > max)
    {
        return 1;
    }
    else if(var >= min && var < middle)
    {
        return (var - min) / (middle - min);
    }
    else if(var >= middle && var < max)
    {
        return (max - var ) / (max - middle);
    }
    else
    {
        return 0;
    }
}

static double TriangularProportion_(double min, double max, double var)
{
    double diff = max - min;
    double middle = min + (diff / 2);
    if(var <= min || var >= max)
    {
        return 0;
    }
    else if(var >= min && var < middle)
    {
        return (var - min) / (middle - min);
    }
    else if(var >= middle && var < max)
    {
        return (max - var ) / (max - middle);
    }
    return 0;
}

ICTriangularFuzzification::ICTriangularFuzzification()
{
}

ICFuzzyMat ICTriangularFuzzification::Fuzzification(double var)
{
    ICFuzzyMat mat(LinguisticVariable());
    mat[0].first = LV_NL;
    mat[1].first = LV_NM;
    mat[2].first = LV_NS;
    mat[3].first = LV_ZO;
    mat[4].first = LV_PS;
    mat[5].first = LV_PM;
    mat[6].first = LV_PL;
    mat[0].second = LeftBoundTriangularProportion(ranges_[0].first, ranges_[0].second, var);
    const int lastErr = LinguisticVariable() - 1;
    for(int i = 1; i != lastErr ; ++i)
    {
        mat[i].second = TriangularProportion_(ranges_[i].first, ranges_[i].second, var);
    }
    mat[lastErr].second = RightBoundTriangularProportion(ranges_[lastErr].first, ranges_[lastErr].second, var);

    return mat;
}

double ICTriangularFuzzification::Singletons(LinguisticVar var) const
{
    switch(var)
    {
    case LV_NL:
    {
        return ranges_[0].first + (ranges_[0].second - ranges_[0].first) / 2;
    }
    break;
    case LV_NM:
    {
        return ranges_[1].first + (ranges_[1].second - ranges_[1].first) / 2;
    }
    break;
    case LV_NS:
    {
        return ranges_[2].first + (ranges_[2].second - ranges_[2].first) / 2;
    }
    break;
    case LV_ZO:
    {
        return ranges_[3].first + (ranges_[3].second - ranges_[3].first) / 2;
    }
    break;
    case LV_PS:
    {
        return ranges_[4].first + (ranges_[4].second - ranges_[4].first) / 2;
    }
    break;
    case LV_PM:
    {
        return ranges_[5].first + (ranges_[5].second - ranges_[5].first) / 2;
    }
    break;
    case LV_PL:
    {
        return ranges_[6].first + (ranges_[6].second - ranges_[6].first) / 2;
    }
    break;
    default:
        return 0;
    }
}
