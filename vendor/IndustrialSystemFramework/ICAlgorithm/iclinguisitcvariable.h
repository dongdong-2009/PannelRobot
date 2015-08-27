#ifndef ICLINGUISITCVARIABLE_H
#define ICLINGUISITCVARIABLE_H

enum LinguisticLevel{
    LL_Small    = 5,   //<5
    LL_Medium  = 7,   //<7
    LL_Large    = 13    //<9
};

enum LinguisticVar{
    LV_NLL,
    LV_NL,
    LV_NMM,
    LV_NM,
    LV_NSS,
    LV_NS,
    LV_ZO,
    LV_PS,
    LV_PSS,
    LV_PM,
    LV_PMM,
    LV_PL,
    LV_PLL
};
int LinguisticVarInLevel(LinguisticLevel ll , LinguisticVar lv);

#endif // ICLINGUISITCVARIABLE_H
