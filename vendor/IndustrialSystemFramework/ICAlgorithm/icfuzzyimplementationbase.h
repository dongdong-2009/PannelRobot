#ifndef ICFUZZYIMPLEMENTATIONBASE_H
#define ICFUZZYIMPLEMENTATIONBASE_H

#include "ICAlgorithm_global.h"
#include "iclinguisitcvariable.h"
#include "icfuzzycommon.h"

class ICALGORITHMSHARED_EXPORT ICFuzzyImplementationBase
{
public:
    ICFuzzyImplementationBase();
    virtual LinguisticLevel LinguisticVariable() const = 0;
    virtual ICFuzzyMat Fuzzification(double var) = 0;
    virtual double Singletons(LinguisticVar var) const = 0;
};

#endif // ICFUZZYIMPLEMENTATIONBASE_H
