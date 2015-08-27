#ifndef ICTRIANGULARFUZZIFICATION_H
#define ICTRIANGULARFUZZIFICATION_H

#include "icfuzzycommon.h"
#include "icfuzzyimplementationbase.h"

class ICALGORITHMSHARED_EXPORT ICTriangularFuzzification : public ICFuzzyImplementationBase
{
public:
    ICTriangularFuzzification();

    virtual LinguisticLevel LinguisticVariable() const { return LL_Medium;}
    virtual ICFuzzyMat Fuzzification(double var);
    virtual double Singletons(LinguisticVar var) const;

    FCRange NLRange() const { return ranges_[0];}
    FCRange NMRange() const { return ranges_[1];}
    FCRange NSRange() const { return ranges_[2];}
    FCRange ZORange() const { return ranges_[3];}
    FCRange PSRange() const { return ranges_[4];}
    FCRange PMRange() const { return ranges_[5];}
    FCRange PLRange() const { return ranges_[6];}

    void SetNLRange(double min, double max) { ranges_[0].first = min; ranges_[0].second = max;}
    void SetNMRange(double min, double max) { ranges_[1].first = min; ranges_[1].second = max;}
    void SetNSRange(double min, double max) { ranges_[2].first = min; ranges_[2].second = max;}
    void SetZORange(double min, double max) { ranges_[3].first = min; ranges_[3].second = max;}
    void SetPSRange(double min, double max) { ranges_[4].first = min; ranges_[4].second = max;}
    void SetPMRange(double min, double max) { ranges_[5].first = min; ranges_[5].second = max;}
    void SetPLRange(double min, double max) { ranges_[6].first = min; ranges_[6].second = max;}


private:
    FCRange ranges_[7];
//    FCRange nmRange_[2];
//    FCRange nsRange_[2];
//    FCRange zoRange_[2];
//    FCRange psRange_[2];
//    FCRange pmRange_[2];
//    FCRange plRange_[2];
};

#endif // ICTRIANGULARFUZZIFICATION_H
