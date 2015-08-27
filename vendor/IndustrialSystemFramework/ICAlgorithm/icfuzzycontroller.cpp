#include "icfuzzycontroller.h"
#include "icfuzzyimplementationbase.h"
#include "icfuzzyrules.h"

ICFuzzyController::ICFuzzyController():
    outputRange_(0, 10),
    errRange_(-10, 10),
    dErrRange_(-10, 10),
    errFuzzyImpl_(NULL),
    dErrFuzzyImpl_(NULL)
{
}

double ICFuzzyController::CalOutput(double err, double dErr)
{
    Q_ASSERT_X(errFuzzyImpl_ != NULL && dErrFuzzyImpl_ != NULL, "ICFuzzyController::CalOutput", "ErrorFuzzification() and DErrorFuzzification() is NULL!");
    if(errFuzzyImpl_ == NULL || dErrFuzzyImpl_ == NULL)
    {
        return 0;
    }
    ICFuzzyMat errMat = errFuzzyImpl_->Fuzzification(err);
    ICFuzzyMat dErrMat = dErrFuzzyImpl_->Fuzzification(dErr);
    LingProportions eLP = errMat.NonZeronLings();
    LingProportions deLP = dErrMat.NonZeronLings();
    double minP;
    double sumP = 0;
    double sumPSingletions = 0;
    LinguisticVar lV[2];
    for(int i = 0; i != eLP.size(); ++i)
    {
        for(int j = 0; j != deLP.size(); ++j)
        {
            lV[0] = eLP.at(i).first;
            lV[1] = deLP.at(j).first;
            minP = qMin(eLP.at(i).second, deLP.at(j).second);
            sumP += minP;
            sumPSingletions += OutputFuzzification()->Singletons(FuzzyRules()->Interpret(lV, 2)) * minP;
        }
    }
    return sumP != 0 ? sumPSingletions / sumP : 0;
//    while(errMat.next())
}
