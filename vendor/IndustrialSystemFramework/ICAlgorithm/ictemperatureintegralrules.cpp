#include "ictemperatureintegralrules.h"

LinguisticVar ICTemperatureIntegralRules::varTable_[7][7] =
{
//    {LV_NL, LV_NL, LV_NM, LV_NM, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NM, LV_NS, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NS, LV_ZO, LV_ZO, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NS, LV_ZO, LV_ZO, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NM, LV_NM, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NM, LV_NS, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NL, LV_NM, LV_NM, LV_NL, LV_NL}

// er:row der:col
//    {LV_NL, LV_NL, LV_NM, LV_NM, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NS, LV_NS, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_ZO, LV_ZO, LV_ZO, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_PS, LV_ZO, LV_ZO, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_ZO, LV_ZO, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NS, LV_NS, LV_NS, LV_NL, LV_NL},
//    {LV_NL, LV_NL, LV_NL, LV_NM, LV_NM, LV_NL, LV_NL}

    {LV_NL, LV_NL, LV_NM, LV_PL, LV_PL, LV_NL, LV_NL},
    {LV_NL, LV_NL, LV_NS, LV_PL, LV_PL, LV_NL, LV_NL},
    {LV_NL, LV_NL, LV_ZO, LV_PS, LV_PS, LV_NL, LV_NL},
    {LV_PL, LV_PS, LV_PS, LV_PS, LV_ZO, LV_ZO, LV_NS},
    {LV_NL, LV_NL, LV_PS, LV_PS, LV_ZO, LV_NL, LV_NL},
    {LV_NL, LV_NL, LV_ZO, LV_ZO, LV_NS, LV_NL, LV_NL},
    {LV_NL, LV_NL, LV_NS, LV_NS, LV_NM, LV_NL, LV_NL}

};
ICTemperatureIntegralRules::ICTemperatureIntegralRules()
{
}
