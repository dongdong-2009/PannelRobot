.pragma library

function cloneObject(ob) {
    return JSON.parse(JSON.stringify(ob));
}

function getRandomNum(Min,Max)
{
    var Range = Max - Min;
    var Rand = Math.random();
    return(Min + Math.round(Rand * Range));
}

function formatDate(date, fmt)
{ //author: meizz
  var o = {
    "M+" : date.getMonth()+1,                 //月份
    "d+" : date.getDate(),                    //日
    "h+" : date.getHours(),                   //小时
    "m+" : date.getMinutes(),                 //分
    "s+" : date.getSeconds(),                 //秒
    "q+" : Math.floor((date.getMonth()+3)/3), //季度
    "S"  : date.getMilliseconds()             //毫秒
  };
  if(/(y+)/.test(fmt))
    fmt=fmt.replace(RegExp.$1, (date.getFullYear()+"").substr(4 - RegExp.$1.length));
  for(var k in o)
    if(new RegExp("("+ k +")").test(fmt))
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
  return fmt;
}

function isDateTimeValid(yy,MM,dd,hh,mm,ss){
    var strDate1 = yy + "/" + MM + "/" + dd + " " + hh + ":" + mm + ":" + ss;
    var date1 = new Date(yy,MM - 1,dd,hh,mm,ss);
    var strDate2 = formatDate(date1, "yyyy/M/d h:m:s");
    return strDate1 === strDate2;
}

function getValueFromBrackets(str){
    var begin = str.indexOf('[') + 1;
    var end = str.indexOf(']');
    return str.slice(begin, end);
}

function parseCalibration(str){

    var ret = [];
    var m = str.match(/MoveAbsJ\s*\S*]/g);
    if(m != null){
        for(var i = 0, len = m.length; i < len; ++i){
//            console.log(m[i]);
            var d = (m[i].match(/[-]*\d+[.]+\d*/g));
            ret.push({"m0":parseFloat(d[0]).toFixed(3),
                      "m1":parseFloat(d[1]).toFixed(3),
                      "m2":parseFloat(d[2]).toFixed(3),
                      "m3":parseFloat(d[3]).toFixed(3),
                      "m4":parseFloat(d[4]).toFixed(3),
                      "m5":parseFloat(d[5]).toFixed(3)});
        }
    }
    return ret;
}

function icCreateObject(comp, parentObj,properties){
    if(comp.status === 1){
        return comp.createObject(parentObj, properties || {});
    }
    console.log("createObject:", comp.errorString());
    return null;
}
