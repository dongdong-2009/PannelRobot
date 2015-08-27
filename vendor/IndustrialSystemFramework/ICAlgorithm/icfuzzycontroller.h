#ifndef ICFUZZYCONTROLLER_H
#define ICFUZZYCONTROLLER_H

#include "ICAlgorithm_global.h"
#include "icfuzzycommon.h"

class ICFuzzyImplementationBase;
class ICFuzzyRules;

class ICALGORITHMSHARED_EXPORT ICFuzzyController
{
public:

    ICFuzzyController();
    FCRange OutputRange() const { return outputRange_;}
    void SetOutputRange(double min, double max) { outputRange_.first = min; outputRange_.second = max;}
    FCRange ErrorRange() const { return errRange_;}
    void SetErrorRange(double min, double max) { errRange_.first = min; errRange_.second = max;}
    FCRange DErrorRange() const { return dErrRange_;}
    void SetDErrorRange(double min, double max) { dErrRange_.first = min; dErrRange_.second = max;}

    ICFuzzyImplementationBase* ErrorFuzzification() { return errFuzzyImpl_;}
    void SetErrorFuzzification(ICFuzzyImplementationBase* fuzzyImpl) { errFuzzyImpl_ = fuzzyImpl;}
    ICFuzzyImplementationBase* DErrorFuzzification() { return dErrFuzzyImpl_;}
    void SetDErrorFuzzification(ICFuzzyImplementationBase* fuzzyImpl) { dErrFuzzyImpl_ = fuzzyImpl;}
    ICFuzzyImplementationBase* OutputFuzzification() { return outputFuzzyImpl_;}
    void SetOutputFuzzification(ICFuzzyImplementationBase* fuzzyImpl) { outputFuzzyImpl_ = fuzzyImpl;}
    ICFuzzyRules* FuzzyRules() { return fuzzyRules_;}
    void SetFuzzyRules(ICFuzzyRules* rules) { fuzzyRules_ = rules;}

    double CalOutput(double err, double dErr);

private:
    FCRange outputRange_;
    FCRange errRange_;
    FCRange dErrRange_;

    ICFuzzyImplementationBase* errFuzzyImpl_;
    ICFuzzyImplementationBase* dErrFuzzyImpl_;
    ICFuzzyImplementationBase* outputFuzzyImpl_;
    ICFuzzyRules* fuzzyRules_;
};

#endif // ICFUZZYCONTROLLER_H
