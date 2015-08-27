#ifndef ICFUZZYRULES_H
#define ICFUZZYRULES_H

#include "ICAlgorithm_global.h"
#include "icfuzzycommon.h"
#include "iclinguisitcvariable.h"

class ICALGORITHMSHARED_EXPORT ICFuzzyRules
{
public:
    ICFuzzyRules();
    virtual LinguisticVar Interpret(LinguisticVar* vars, int size) const = 0;
};

#endif // ICFUZZYRULES_H
