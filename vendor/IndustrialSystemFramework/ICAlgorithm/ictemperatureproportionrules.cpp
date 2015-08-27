#include "ictemperatureproportionrules.h"

LinguisticVar ICTemperatureProportionRules::varTable_[7][7] =
{
    {LV_PL, LV_PL, LV_PM, LV_PM, LV_PS, LV_ZO, LV_PS},
    {LV_PL, LV_PL, LV_PM, LV_PS, LV_PS, LV_ZO, LV_ZO},
    {LV_PL, LV_PM, LV_PM, LV_PS, LV_ZO, LV_ZO, LV_ZO},
    {LV_PM, LV_PM, LV_PS, LV_ZO, LV_NS, LV_PS, LV_PM},
    {LV_PS, LV_PS, LV_ZO, LV_PS, LV_PS, LV_PM, LV_PM},
    {LV_PS, LV_ZO, LV_NS, LV_PS, LV_PM, LV_PM, LV_PL},
    {LV_ZO, LV_ZO, LV_NM, LV_PM, LV_PL, LV_PL, LV_PL}
//    {LV_PL, LV_PL, LV_NL, LV_PM, LV_PS, LV_PS, LV_ZO},
//    {LV_PL, LV_PL, LV_NM, LV_PM, LV_PS, LV_ZO, LV_ZO},
//    {LV_PL, LV_PM, LV_NS, LV_PS, LV_ZO, LV_NS, LV_NM},
//    {LV_PM, LV_PS, LV_ZO, LV_ZO, LV_NS, LV_NM, LV_NM},
//    {LV_PS, LV_PS, LV_ZO, LV_NS, LV_NS, LV_NM, LV_NM},
//    {LV_ZO, LV_ZO, LV_NS, LV_NM, LV_NM, LV_NM, LV_NL},
//    {LV_ZO, LV_NS, LV_NS, LV_NM, LV_NM, LV_NL, LV_NL}
};
ICTemperatureProportionRules::ICTemperatureProportionRules()
{

}
