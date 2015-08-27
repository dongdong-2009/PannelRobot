#include "iclinguisitcvariable.h"

int LinguisticVarInLevel(LinguisticLevel ll , LinguisticVar lv)
{
    switch(ll)
    {
    case LL_Small:
    {
        if(lv == LV_ZO)
        {
            return 2;
        }
        else if(lv >= LV_NLL && lv <= LV_NMM)
        {
            return 0;
        }
        else if(lv >= LV_NM && lv <= LV_NS)
        {
            return 1;
        }
        else if(lv >= LV_PS && lv <= LV_PM)
        {
            return 3;
        }
        else
        {
            return 4;
        }
    }
    break;
    case LL_Medium:
    {
        if(lv == LV_ZO)
        {
            return 3;
        }
        if(lv >= LV_NLL && lv <= LV_NL)
        {
            return 0;
        }
        else if(lv >= LV_NMM && lv <= LV_NM)
        {
            return 1;
        }
        else if(lv >= LV_NSS && lv <= LV_NS)
        {
            return 2;
        }
        else if(lv >= LV_PS && lv <= LV_PSS)
        {
            return 4;
        }
        else if(lv >= LV_PM && lv <= LV_PMM)
        {
            return 5;
        }
        else
        {
            return 6;
        }
    }
    break;
    case LL_Large:
    {
        return lv;
    }
    }
    return LV_NLL;
}
