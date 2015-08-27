#include "ictemperaturedifferentialrules.h"

LinguisticVar ICTemperatureDifferentialRules::varTable_[7][7] =
{
    {LV_PL, LV_PM, LV_PL, LV_PL, LV_NS, LV_NM, LV_NM},
    {LV_PL, LV_PM, LV_PL, LV_PL, LV_NM, LV_NS, LV_NS},
    {LV_PL, LV_PM, LV_PL, LV_PM, LV_NM, LV_NS, LV_NS},
    {LV_ZO, LV_ZO, LV_NS, LV_NS, LV_NS, LV_NS, LV_ZO},
    {LV_ZO, LV_ZO, LV_NS, LV_ZO, LV_ZO, LV_PS, LV_PS},
    {LV_NS, LV_NS, LV_ZO, LV_PS, LV_PS, LV_PM, LV_PL},
    {LV_NS, LV_NS, LV_ZO, LV_PM, LV_PM, LV_PL, LV_PL}
};
ICTemperatureDifferentialRules::ICTemperatureDifferentialRules()
{
}
