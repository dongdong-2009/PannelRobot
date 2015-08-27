#ifndef ICFUZZYCOMMON_H
#define ICFUZZYCOMMON_H

#include "ICAlgorithm_global.h"

#include <QPair>
#include <QVector>
#include "iclinguisitcvariable.h"
typedef QPair<double, double> FCRange;
typedef QPair<LinguisticVar, double> LingProportion;
typedef QVector<LingProportion > LingProportions;

class ICALGORITHMSHARED_EXPORT ICFuzzyMat
{
public:
    ICFuzzyMat(int num):linguisticProportion_(num, qMakePair(LinguisticVar(0), 0.0))
    {
    }

    LingProportion& operator[](int index) {return linguisticProportion_[index];}
    LingProportion operator[](int index) const  {return linguisticProportion_.at(index);}

    LingProportions NonZeronLings() const;
private:
    LingProportions linguisticProportion_;
};


inline LingProportions ICFuzzyMat::NonZeronLings() const
{
    LingProportions ret;
    for(int i = 0; i != linguisticProportion_.size(); ++i)
    {
        if(linguisticProportion_.at(i).second != 0)
        {
            ret.append(linguisticProportion_.at(i));
        }
    }
    return ret;
}

#endif // ICFUZZYCOMMON_H
