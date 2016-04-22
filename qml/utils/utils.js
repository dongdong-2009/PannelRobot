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

var gcodeLineParser = (function() {
    function peg$subclass(child, parent) {
        function ctor() { this.constructor = child; }
        ctor.prototype = parent.prototype;
        child.prototype = new ctor();
    }

    function peg$SyntaxError(message, expected, found, location) {
        this.message  = message;
        this.expected = expected;
        this.found    = found;
        this.location = location;
        this.name     = "SyntaxError";

        if (typeof Error.captureStackTrace === "function") {
            Error.captureStackTrace(this, peg$SyntaxError);
        }
    }

    peg$subclass(peg$SyntaxError, Error);

    function peg$parse(input) {
        var options = arguments.length > 1 ? arguments[1] : {},
        parser  = this,

                peg$FAILED = {},

        peg$startRuleFunctions = { start: peg$parsestart },
        peg$startRuleFunction  = peg$parsestart,

                peg$c0 = function(num, words) {
                    return {'words':words}
                },
        peg$c1 = function(word, value) { return [word, value]; },
        peg$c2 = "N",
                peg$c3 = { type: "literal", value: "N", description: "\"N\"" },
        peg$c4 = /^[0-9]/,
                peg$c5 = { type: "class", value: "[0-9]", description: "[0-9]" },
        peg$c6 = function() { return parseInt(text()); },
        peg$c7 = /^[+\-]/,
                peg$c8 = { type: "class", value: "[\\+\\-]", description: "[\\+\\-]" },
        peg$c9 = /^[.]/,
                peg$c10 = { type: "class", value: "[\\.]", description: "[\\.]" },
        peg$c11 = function() { return parseFloat(text()); },
        peg$c12 = "[",
                peg$c13 = { type: "literal", value: "[", description: "\"[\"" },
        peg$c14 = "]",
                peg$c15 = { type: "literal", value: "]", description: "\"]\"" },
        peg$c16 = function(expr) {return expr; },
        peg$c17 = "ATAN",
                peg$c18 = { type: "literal", value: "ATAN", description: "\"ATAN\"" },
        peg$c19 = "/",
                peg$c20 = { type: "literal", value: "/", description: "\"/\"" },
        peg$c21 = function(left, right) {
            return {'op':"ATAN", 'left':left, 'right':right};
        },
        peg$c22 = function(op, expr) {return {'op':op, 'right':expr}},
        peg$c23 = "#",
                peg$c24 = { type: "literal", value: "#", description: "\"#\"" },
        peg$c25 = function(expr) { return {'op':'#', 'right':expr }},
        peg$c26 = function(first, rest) {
            return buildTree(first, rest);
        },
        peg$c27 = function(first, rest) {
            return buildTree(first, rest);
        },
        peg$c28 = "**",
                peg$c29 = { type: "literal", value: "**", description: "\"**\"" },
        peg$c30 = "*",
                peg$c31 = { type: "literal", value: "*", description: "\"*\"" },
        peg$c32 = "MOD",
                peg$c33 = { type: "literal", value: "MOD", description: "\"MOD\"" },
        peg$c34 = "+",
                peg$c35 = { type: "literal", value: "+", description: "\"+\"" },
        peg$c36 = "-",
                peg$c37 = { type: "literal", value: "-", description: "\"-\"" },
        peg$c38 = "OR",
                peg$c39 = { type: "literal", value: "OR", description: "\"OR\"" },
        peg$c40 = "XOR",
                peg$c41 = { type: "literal", value: "XOR", description: "\"XOR\"" },
        peg$c42 = "AND",
                peg$c43 = { type: "literal", value: "AND", description: "\"AND\"" },
        peg$c44 = "ABS",
                peg$c45 = { type: "literal", value: "ABS", description: "\"ABS\"" },
        peg$c46 = "ACOS",
                peg$c47 = { type: "literal", value: "ACOS", description: "\"ACOS\"" },
        peg$c48 = "ASIN",
                peg$c49 = { type: "literal", value: "ASIN", description: "\"ASIN\"" },
        peg$c50 = "COS",
                peg$c51 = { type: "literal", value: "COS", description: "\"COS\"" },
        peg$c52 = "EXP",
                peg$c53 = { type: "literal", value: "EXP", description: "\"EXP\"" },
        peg$c54 = "FIX",
                peg$c55 = { type: "literal", value: "FIX", description: "\"FIX\"" },
        peg$c56 = "FUP",
                peg$c57 = { type: "literal", value: "FUP", description: "\"FUP\"" },
        peg$c58 = "ROUND",
                peg$c59 = { type: "literal", value: "ROUND", description: "\"ROUND\"" },
        peg$c60 = "LN",
                peg$c61 = { type: "literal", value: "LN", description: "\"LN\"" },
        peg$c62 = "SIN",
                peg$c63 = { type: "literal", value: "SIN", description: "\"SIN\"" },
        peg$c64 = "SQRT",
                peg$c65 = { type: "literal", value: "SQRT", description: "\"SQRT\"" },
        peg$c66 = "TAN",
                peg$c67 = { type: "literal", value: "TAN", description: "\"TAN\"" },
        peg$c68 = "EXISTS",
                peg$c69 = { type: "literal", value: "EXISTS", description: "\"EXISTS\"" },
        peg$c70 = "A",
                peg$c71 = { type: "literal", value: "A", description: "\"A\"" },
        peg$c72 = "B",
                peg$c73 = { type: "literal", value: "B", description: "\"B\"" },
        peg$c74 = "C",
                peg$c75 = { type: "literal", value: "C", description: "\"C\"" },
        peg$c76 = "D",
                peg$c77 = { type: "literal", value: "D", description: "\"D\"" },
        peg$c78 = "F",
                peg$c79 = { type: "literal", value: "F", description: "\"F\"" },
        peg$c80 = "G",
                peg$c81 = { type: "literal", value: "G", description: "\"G\"" },
        peg$c82 = "H",
                peg$c83 = { type: "literal", value: "H", description: "\"H\"" },
        peg$c84 = "I",
                peg$c85 = { type: "literal", value: "I", description: "\"I\"" },
        peg$c86 = "J",
                peg$c87 = { type: "literal", value: "J", description: "\"J\"" },
        peg$c88 = "K",
                peg$c89 = { type: "literal", value: "K", description: "\"K\"" },
        peg$c90 = "L",
                peg$c91 = { type: "literal", value: "L", description: "\"L\"" },
        peg$c92 = "M",
                peg$c93 = { type: "literal", value: "M", description: "\"M\"" },
        peg$c94 = "P",
                peg$c95 = { type: "literal", value: "P", description: "\"P\"" },
        peg$c96 = "Q",
                peg$c97 = { type: "literal", value: "Q", description: "\"Q\"" },
        peg$c98 = "R",
                peg$c99 = { type: "literal", value: "R", description: "\"R\"" },
        peg$c100 = "S",
                peg$c101 = { type: "literal", value: "S", description: "\"S\"" },
        peg$c102 = "T",
                peg$c103 = { type: "literal", value: "T", description: "\"T\"" },
        peg$c104 = "X",
                peg$c105 = { type: "literal", value: "X", description: "\"X\"" },
        peg$c106 = "Y",
                peg$c107 = { type: "literal", value: "Y", description: "\"Y\"" },
        peg$c108 = "Z",
                peg$c109 = { type: "literal", value: "Z", description: "\"Z\"" },
        peg$c110 = "U",
                peg$c111 = { type: "literal", value: "U", description: "\"U\"" },
        peg$c112 = "V",
                peg$c113 = { type: "literal", value: "V", description: "\"V\"" },
        peg$c114 = "W",
                peg$c115 = { type: "literal", value: "W", description: "\"W\"" },

        peg$currPos          = 0,
                peg$savedPos         = 0,
                peg$posDetailsCache  = [{ line: 1, column: 1, seenCR: false }],
                peg$maxFailPos       = 0,
                peg$maxFailExpected  = [],
                peg$silentFails      = 0,

                peg$result;

        if ("startRule" in options) {
            if (!(options.startRule in peg$startRuleFunctions)) {
                throw new Error("Can't start parsing from rule \"" + options.startRule + "\".");
            }

            peg$startRuleFunction = peg$startRuleFunctions[options.startRule];
        }

        function text() {
            return input.substring(peg$savedPos, peg$currPos);
        }

        function location() {
            return peg$computeLocation(peg$savedPos, peg$currPos);
        }

        function expected(description) {
            throw peg$buildException(
                        null,
                        [{ type: "other", description: description }],
                        input.substring(peg$savedPos, peg$currPos),
                        peg$computeLocation(peg$savedPos, peg$currPos)
                        );
        }

        function error(message) {
            throw peg$buildException(
                        message,
                        null,
                        input.substring(peg$savedPos, peg$currPos),
                        peg$computeLocation(peg$savedPos, peg$currPos)
                        );
        }

        function peg$computePosDetails(pos) {
            var details = peg$posDetailsCache[pos],
                    p, ch;

            if (details) {
                return details;
            } else {
                p = pos - 1;
                while (!peg$posDetailsCache[p]) {
                    p--;
                }

                details = peg$posDetailsCache[p];
                details = {
                    line:   details.line,
                    column: details.column,
                    seenCR: details.seenCR
                };

                while (p < pos) {
                    ch = input.charAt(p);
                    if (ch === "\n") {
                        if (!details.seenCR) { details.line++; }
                        details.column = 1;
                        details.seenCR = false;
                    } else if (ch === "\r" || ch === "\u2028" || ch === "\u2029") {
                        details.line++;
                        details.column = 1;
                        details.seenCR = true;
                    } else {
                        details.column++;
                        details.seenCR = false;
                    }

                    p++;
                }

                peg$posDetailsCache[pos] = details;
                return details;
            }
        }

        function peg$computeLocation(startPos, endPos) {
            var startPosDetails = peg$computePosDetails(startPos),
                    endPosDetails   = peg$computePosDetails(endPos);

            return {
                start: {
                    offset: startPos,
                    line:   startPosDetails.line,
                    column: startPosDetails.column
                },
                end: {
                    offset: endPos,
                    line:   endPosDetails.line,
                    column: endPosDetails.column
                }
            };
        }

        function peg$fail(expected) {
            if (peg$currPos < peg$maxFailPos) { return; }

            if (peg$currPos > peg$maxFailPos) {
                peg$maxFailPos = peg$currPos;
                peg$maxFailExpected = [];
            }

            peg$maxFailExpected.push(expected);
        }

        function peg$buildException(message, expected, found, location) {
            function cleanupExpected(expected) {
                var i = 1;

                expected.sort(function(a, b) {
                    if (a.description < b.description) {
                        return -1;
                    } else if (a.description > b.description) {
                        return 1;
                    } else {
                        return 0;
                    }
                });

                while (i < expected.length) {
                    if (expected[i - 1] === expected[i]) {
                        expected.splice(i, 1);
                    } else {
                        i++;
                    }
                }
            }

            function buildMessage(expected, found) {
                function stringEscape(s) {
                    function hex(ch) { return ch.charCodeAt(0).toString(16).toUpperCase(); }

                    return s
                    .replace(/\\/g,   '\\\\')
                    .replace(/"/g,    '\\"')
                    .replace(/\x08/g, '\\b')
                    .replace(/\t/g,   '\\t')
                    .replace(/\n/g,   '\\n')
                    .replace(/\f/g,   '\\f')
                    .replace(/\r/g,   '\\r')
                    .replace(/[\x00-\x07\x0B\x0E\x0F]/g, function(ch) { return '\\x0' + hex(ch); })
                    .replace(/[\x10-\x1F\x80-\xFF]/g,    function(ch) { return '\\x'  + hex(ch); })
                    .replace(/[\u0100-\u0FFF]/g,         function(ch) { return '\\u0' + hex(ch); })
                    .replace(/[\u1000-\uFFFF]/g,         function(ch) { return '\\u'  + hex(ch); });
                }

                var expectedDescs = new Array(expected.length),
                        expectedDesc, foundDesc, i;

                for (i = 0; i < expected.length; i++) {
                    expectedDescs[i] = expected[i].description;
                }

                expectedDesc = expected.length > 1
                        ? expectedDescs.slice(0, -1).join(", ")
                          + " or "
                          + expectedDescs[expected.length - 1]
                        : expectedDescs[0];

                foundDesc = found ? "\"" + stringEscape(found) + "\"" : "end of input";

                return "Expected " + expectedDesc + " but " + foundDesc + " found.";
            }

            if (expected !== null) {
                cleanupExpected(expected);
            }

            return new peg$SyntaxError(
                        message !== null ? message : buildMessage(expected, found),
                                           expected,
                                           found,
                                           location
                        );
        }

        function peg$parsestart() {
            var s0;

            s0 = peg$parseline();

            return s0;
        }

        function peg$parseline() {
            var s0, s1, s2, s3;

            s0 = peg$currPos;
            s1 = peg$parseline_number();
            if (s1 === peg$FAILED) {
                s1 = null;
            }
            if (s1 !== peg$FAILED) {
                s2 = [];
                s3 = peg$parseword();
                while (s3 !== peg$FAILED) {
                    s2.push(s3);
                    s3 = peg$parseword();
                }
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c0(s1, s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseword() {
            var s0, s1, s2;

            s0 = peg$currPos;
            s1 = peg$parseletter();
            if (s1 !== peg$FAILED) {
                s2 = peg$parsefactor1();
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c1(s1, s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseline_number() {
            var s0, s1, s2;

            s0 = peg$currPos;
            if (input.charCodeAt(peg$currPos) === 78) {
                s1 = peg$c2;
                peg$currPos++;
            } else {
                s1 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c3); }
            }
            if (s1 !== peg$FAILED) {
                s2 = peg$parseinteger();
                if (s2 !== peg$FAILED) {
                    s1 = [s1, s2];
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseinteger() {
            var s0, s1, s2;

            s0 = peg$currPos;
            s1 = [];
            if (peg$c4.test(input.charAt(peg$currPos))) {
                s2 = input.charAt(peg$currPos);
                peg$currPos++;
            } else {
                s2 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c5); }
            }
            if (s2 !== peg$FAILED) {
                while (s2 !== peg$FAILED) {
                    s1.push(s2);
                    if (peg$c4.test(input.charAt(peg$currPos))) {
                        s2 = input.charAt(peg$currPos);
                        peg$currPos++;
                    } else {
                        s2 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c5); }
                    }
                }
            } else {
                s1 = peg$FAILED;
            }
            if (s1 !== peg$FAILED) {
                peg$savedPos = s0;
                s1 = peg$c6();
            }
            s0 = s1;

            return s0;
        }

        function peg$parsenumber() {
            var s0, s1, s2, s3, s4, s5, s6;

            s0 = peg$currPos;
            if (peg$c7.test(input.charAt(peg$currPos))) {
                s1 = input.charAt(peg$currPos);
                peg$currPos++;
            } else {
                s1 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c8); }
            }
            if (s1 === peg$FAILED) {
                s1 = null;
            }
            if (s1 !== peg$FAILED) {
                s2 = [];
                if (peg$c4.test(input.charAt(peg$currPos))) {
                    s3 = input.charAt(peg$currPos);
                    peg$currPos++;
                } else {
                    s3 = peg$FAILED;
                    if (peg$silentFails === 0) { peg$fail(peg$c5); }
                }
                if (s3 !== peg$FAILED) {
                    while (s3 !== peg$FAILED) {
                        s2.push(s3);
                        if (peg$c4.test(input.charAt(peg$currPos))) {
                            s3 = input.charAt(peg$currPos);
                            peg$currPos++;
                        } else {
                            s3 = peg$FAILED;
                            if (peg$silentFails === 0) { peg$fail(peg$c5); }
                        }
                    }
                } else {
                    s2 = peg$FAILED;
                }
                if (s2 !== peg$FAILED) {
                    s3 = peg$currPos;
                    if (peg$c9.test(input.charAt(peg$currPos))) {
                        s4 = input.charAt(peg$currPos);
                        peg$currPos++;
                    } else {
                        s4 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c10); }
                    }
                    if (s4 !== peg$FAILED) {
                        s5 = [];
                        if (peg$c4.test(input.charAt(peg$currPos))) {
                            s6 = input.charAt(peg$currPos);
                            peg$currPos++;
                        } else {
                            s6 = peg$FAILED;
                            if (peg$silentFails === 0) { peg$fail(peg$c5); }
                        }
                        while (s6 !== peg$FAILED) {
                            s5.push(s6);
                            if (peg$c4.test(input.charAt(peg$currPos))) {
                                s6 = input.charAt(peg$currPos);
                                peg$currPos++;
                            } else {
                                s6 = peg$FAILED;
                                if (peg$silentFails === 0) { peg$fail(peg$c5); }
                            }
                        }
                        if (s5 !== peg$FAILED) {
                            s4 = [s4, s5];
                            s3 = s4;
                        } else {
                            peg$currPos = s3;
                            s3 = peg$FAILED;
                        }
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                    if (s3 === peg$FAILED) {
                        s3 = null;
                    }
                    if (s3 !== peg$FAILED) {
                        peg$savedPos = s0;
                        s1 = peg$c11();
                        s0 = s1;
                    } else {
                        peg$currPos = s0;
                        s0 = peg$FAILED;
                    }
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseexpression() {
            var s0, s1, s2, s3;

            s0 = peg$currPos;
            if (input.charCodeAt(peg$currPos) === 91) {
                s1 = peg$c12;
                peg$currPos++;
            } else {
                s1 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c13); }
            }
            if (s1 !== peg$FAILED) {
                s2 = peg$parsefactor4();
                if (s2 !== peg$FAILED) {
                    if (input.charCodeAt(peg$currPos) === 93) {
                        s3 = peg$c14;
                        peg$currPos++;
                    } else {
                        s3 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c15); }
                    }
                    if (s3 !== peg$FAILED) {
                        peg$savedPos = s0;
                        s1 = peg$c16(s2);
                        s0 = s1;
                    } else {
                        peg$currPos = s0;
                        s0 = peg$FAILED;
                    }
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseatan_factor() {
            var s0, s1, s2, s3, s4;

            s0 = peg$currPos;
            if (input.substr(peg$currPos, 4) === peg$c17) {
                s1 = peg$c17;
                peg$currPos += 4;
            } else {
                s1 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c18); }
            }
            if (s1 !== peg$FAILED) {
                s2 = peg$parseexpression();
                if (s2 !== peg$FAILED) {
                    if (input.charCodeAt(peg$currPos) === 47) {
                        s3 = peg$c19;
                        peg$currPos++;
                    } else {
                        s3 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c20); }
                    }
                    if (s3 !== peg$FAILED) {
                        s4 = peg$parseexpression();
                        if (s4 !== peg$FAILED) {
                            peg$savedPos = s0;
                            s1 = peg$c21(s2, s4);
                            s0 = s1;
                        } else {
                            peg$currPos = s0;
                            s0 = peg$FAILED;
                        }
                    } else {
                        peg$currPos = s0;
                        s0 = peg$FAILED;
                    }
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseunary_factor() {
            var s0, s1, s2;

            s0 = peg$currPos;
            s1 = peg$parseunary_op();
            if (s1 !== peg$FAILED) {
                s2 = peg$parseexpression();
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c22(s1, s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parseparam_value() {
            var s0, s1, s2;

            s0 = peg$currPos;
            if (input.charCodeAt(peg$currPos) === 35) {
                s1 = peg$c23;
                peg$currPos++;
            } else {
                s1 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c24); }
            }
            if (s1 !== peg$FAILED) {
                s2 = peg$parseexpression();
                if (s2 === peg$FAILED) {
                    s2 = peg$parsenumber();
                    if (s2 === peg$FAILED) {
                        s2 = peg$parseparam_value();
                    }
                }
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c25(s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parsefactor1() {
            var s0;

            s0 = peg$parseexpression();
            if (s0 === peg$FAILED) {
                s0 = peg$parsenumber();
                if (s0 === peg$FAILED) {
                    s0 = peg$parseatan_factor();
                    if (s0 === peg$FAILED) {
                        s0 = peg$parseunary_factor();
                        if (s0 === peg$FAILED) {
                            s0 = peg$parseparam_value();
                        }
                    }
                }
            }

            return s0;
        }

        function peg$parsefactor2() {
            var s0, s1, s2, s3, s4, s5;

            s0 = peg$currPos;
            s1 = peg$parsefactor1();
            if (s1 !== peg$FAILED) {
                s2 = [];
                s3 = peg$currPos;
                s4 = peg$parsegroup1_op();
                if (s4 !== peg$FAILED) {
                    s5 = peg$parsefactor1();
                    if (s5 !== peg$FAILED) {
                        s4 = [s4, s5];
                        s3 = s4;
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                } else {
                    peg$currPos = s3;
                    s3 = peg$FAILED;
                }
                while (s3 !== peg$FAILED) {
                    s2.push(s3);
                    s3 = peg$currPos;
                    s4 = peg$parsegroup1_op();
                    if (s4 !== peg$FAILED) {
                        s5 = peg$parsefactor1();
                        if (s5 !== peg$FAILED) {
                            s4 = [s4, s5];
                            s3 = s4;
                        } else {
                            peg$currPos = s3;
                            s3 = peg$FAILED;
                        }
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                }
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c26(s1, s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parsefactor3() {
            var s0, s1, s2, s3, s4, s5;

            s0 = peg$currPos;
            s1 = peg$parsefactor2();
            if (s1 !== peg$FAILED) {
                s2 = [];
                s3 = peg$currPos;
                s4 = peg$parsegroup2_op();
                if (s4 !== peg$FAILED) {
                    s5 = peg$parsefactor2();
                    if (s5 !== peg$FAILED) {
                        s4 = [s4, s5];
                        s3 = s4;
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                } else {
                    peg$currPos = s3;
                    s3 = peg$FAILED;
                }
                while (s3 !== peg$FAILED) {
                    s2.push(s3);
                    s3 = peg$currPos;
                    s4 = peg$parsegroup2_op();
                    if (s4 !== peg$FAILED) {
                        s5 = peg$parsefactor2();
                        if (s5 !== peg$FAILED) {
                            s4 = [s4, s5];
                            s3 = s4;
                        } else {
                            peg$currPos = s3;
                            s3 = peg$FAILED;
                        }
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                }
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c27(s1, s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parsefactor4() {
            var s0, s1, s2, s3, s4, s5;

            s0 = peg$currPos;
            s1 = peg$parsefactor3();
            if (s1 !== peg$FAILED) {
                s2 = [];
                s3 = peg$currPos;
                s4 = peg$parsegroup3_op();
                if (s4 !== peg$FAILED) {
                    s5 = peg$parsefactor3();
                    if (s5 !== peg$FAILED) {
                        s4 = [s4, s5];
                        s3 = s4;
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                } else {
                    peg$currPos = s3;
                    s3 = peg$FAILED;
                }
                while (s3 !== peg$FAILED) {
                    s2.push(s3);
                    s3 = peg$currPos;
                    s4 = peg$parsegroup3_op();
                    if (s4 !== peg$FAILED) {
                        s5 = peg$parsefactor3();
                        if (s5 !== peg$FAILED) {
                            s4 = [s4, s5];
                            s3 = s4;
                        } else {
                            peg$currPos = s3;
                            s3 = peg$FAILED;
                        }
                    } else {
                        peg$currPos = s3;
                        s3 = peg$FAILED;
                    }
                }
                if (s2 !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c27(s1, s2);
                    s0 = s1;
                } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                }
            } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
            }

            return s0;
        }

        function peg$parsegroup1_op() {
            var s0;

            if (input.substr(peg$currPos, 2) === peg$c28) {
                s0 = peg$c28;
                peg$currPos += 2;
            } else {
                s0 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c29); }
            }

            return s0;
        }

        function peg$parsegroup2_op() {
            var s0;

            if (input.charCodeAt(peg$currPos) === 42) {
                s0 = peg$c30;
                peg$currPos++;
            } else {
                s0 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c31); }
            }
            if (s0 === peg$FAILED) {
                if (input.charCodeAt(peg$currPos) === 47) {
                    s0 = peg$c19;
                    peg$currPos++;
                } else {
                    s0 = peg$FAILED;
                    if (peg$silentFails === 0) { peg$fail(peg$c20); }
                }
                if (s0 === peg$FAILED) {
                    if (input.substr(peg$currPos, 3) === peg$c32) {
                        s0 = peg$c32;
                        peg$currPos += 3;
                    } else {
                        s0 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c33); }
                    }
                }
            }

            return s0;
        }

        function peg$parsegroup3_op() {
            var s0;

            if (input.charCodeAt(peg$currPos) === 43) {
                s0 = peg$c34;
                peg$currPos++;
            } else {
                s0 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c35); }
            }
            if (s0 === peg$FAILED) {
                if (input.charCodeAt(peg$currPos) === 45) {
                    s0 = peg$c36;
                    peg$currPos++;
                } else {
                    s0 = peg$FAILED;
                    if (peg$silentFails === 0) { peg$fail(peg$c37); }
                }
                if (s0 === peg$FAILED) {
                    if (input.substr(peg$currPos, 2) === peg$c38) {
                        s0 = peg$c38;
                        peg$currPos += 2;
                    } else {
                        s0 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c39); }
                    }
                    if (s0 === peg$FAILED) {
                        if (input.substr(peg$currPos, 3) === peg$c40) {
                            s0 = peg$c40;
                            peg$currPos += 3;
                        } else {
                            s0 = peg$FAILED;
                            if (peg$silentFails === 0) { peg$fail(peg$c41); }
                        }
                        if (s0 === peg$FAILED) {
                            if (input.substr(peg$currPos, 3) === peg$c42) {
                                s0 = peg$c42;
                                peg$currPos += 3;
                            } else {
                                s0 = peg$FAILED;
                                if (peg$silentFails === 0) { peg$fail(peg$c43); }
                            }
                        }
                    }
                }
            }

            return s0;
        }

        function peg$parseunary_op() {
            var s0;

            if (input.substr(peg$currPos, 3) === peg$c44) {
                s0 = peg$c44;
                peg$currPos += 3;
            } else {
                s0 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c45); }
            }
            if (s0 === peg$FAILED) {
                if (input.substr(peg$currPos, 4) === peg$c46) {
                    s0 = peg$c46;
                    peg$currPos += 4;
                } else {
                    s0 = peg$FAILED;
                    if (peg$silentFails === 0) { peg$fail(peg$c47); }
                }
                if (s0 === peg$FAILED) {
                    if (input.substr(peg$currPos, 4) === peg$c48) {
                        s0 = peg$c48;
                        peg$currPos += 4;
                    } else {
                        s0 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c49); }
                    }
                    if (s0 === peg$FAILED) {
                        if (input.substr(peg$currPos, 3) === peg$c50) {
                            s0 = peg$c50;
                            peg$currPos += 3;
                        } else {
                            s0 = peg$FAILED;
                            if (peg$silentFails === 0) { peg$fail(peg$c51); }
                        }
                        if (s0 === peg$FAILED) {
                            if (input.substr(peg$currPos, 3) === peg$c52) {
                                s0 = peg$c52;
                                peg$currPos += 3;
                            } else {
                                s0 = peg$FAILED;
                                if (peg$silentFails === 0) { peg$fail(peg$c53); }
                            }
                            if (s0 === peg$FAILED) {
                                if (input.substr(peg$currPos, 3) === peg$c54) {
                                    s0 = peg$c54;
                                    peg$currPos += 3;
                                } else {
                                    s0 = peg$FAILED;
                                    if (peg$silentFails === 0) { peg$fail(peg$c55); }
                                }
                                if (s0 === peg$FAILED) {
                                    if (input.substr(peg$currPos, 3) === peg$c56) {
                                        s0 = peg$c56;
                                        peg$currPos += 3;
                                    } else {
                                        s0 = peg$FAILED;
                                        if (peg$silentFails === 0) { peg$fail(peg$c57); }
                                    }
                                    if (s0 === peg$FAILED) {
                                        if (input.substr(peg$currPos, 5) === peg$c58) {
                                            s0 = peg$c58;
                                            peg$currPos += 5;
                                        } else {
                                            s0 = peg$FAILED;
                                            if (peg$silentFails === 0) { peg$fail(peg$c59); }
                                        }
                                        if (s0 === peg$FAILED) {
                                            if (input.substr(peg$currPos, 2) === peg$c60) {
                                                s0 = peg$c60;
                                                peg$currPos += 2;
                                            } else {
                                                s0 = peg$FAILED;
                                                if (peg$silentFails === 0) { peg$fail(peg$c61); }
                                            }
                                            if (s0 === peg$FAILED) {
                                                if (input.substr(peg$currPos, 3) === peg$c62) {
                                                    s0 = peg$c62;
                                                    peg$currPos += 3;
                                                } else {
                                                    s0 = peg$FAILED;
                                                    if (peg$silentFails === 0) { peg$fail(peg$c63); }
                                                }
                                                if (s0 === peg$FAILED) {
                                                    if (input.substr(peg$currPos, 4) === peg$c64) {
                                                        s0 = peg$c64;
                                                        peg$currPos += 4;
                                                    } else {
                                                        s0 = peg$FAILED;
                                                        if (peg$silentFails === 0) { peg$fail(peg$c65); }
                                                    }
                                                    if (s0 === peg$FAILED) {
                                                        if (input.substr(peg$currPos, 3) === peg$c66) {
                                                            s0 = peg$c66;
                                                            peg$currPos += 3;
                                                        } else {
                                                            s0 = peg$FAILED;
                                                            if (peg$silentFails === 0) { peg$fail(peg$c67); }
                                                        }
                                                        if (s0 === peg$FAILED) {
                                                            if (input.substr(peg$currPos, 6) === peg$c68) {
                                                                s0 = peg$c68;
                                                                peg$currPos += 6;
                                                            } else {
                                                                s0 = peg$FAILED;
                                                                if (peg$silentFails === 0) { peg$fail(peg$c69); }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return s0;
        }

        function peg$parseletter() {
            var s0;

            if (input.charCodeAt(peg$currPos) === 65) {
                s0 = peg$c70;
                peg$currPos++;
            } else {
                s0 = peg$FAILED;
                if (peg$silentFails === 0) { peg$fail(peg$c71); }
            }
            if (s0 === peg$FAILED) {
                if (input.charCodeAt(peg$currPos) === 66) {
                    s0 = peg$c72;
                    peg$currPos++;
                } else {
                    s0 = peg$FAILED;
                    if (peg$silentFails === 0) { peg$fail(peg$c73); }
                }
                if (s0 === peg$FAILED) {
                    if (input.charCodeAt(peg$currPos) === 67) {
                        s0 = peg$c74;
                        peg$currPos++;
                    } else {
                        s0 = peg$FAILED;
                        if (peg$silentFails === 0) { peg$fail(peg$c75); }
                    }
                    if (s0 === peg$FAILED) {
                        if (input.charCodeAt(peg$currPos) === 68) {
                            s0 = peg$c76;
                            peg$currPos++;
                        } else {
                            s0 = peg$FAILED;
                            if (peg$silentFails === 0) { peg$fail(peg$c77); }
                        }
                        if (s0 === peg$FAILED) {
                            if (input.charCodeAt(peg$currPos) === 70) {
                                s0 = peg$c78;
                                peg$currPos++;
                            } else {
                                s0 = peg$FAILED;
                                if (peg$silentFails === 0) { peg$fail(peg$c79); }
                            }
                            if (s0 === peg$FAILED) {
                                if (input.charCodeAt(peg$currPos) === 71) {
                                    s0 = peg$c80;
                                    peg$currPos++;
                                } else {
                                    s0 = peg$FAILED;
                                    if (peg$silentFails === 0) { peg$fail(peg$c81); }
                                }
                                if (s0 === peg$FAILED) {
                                    if (input.charCodeAt(peg$currPos) === 72) {
                                        s0 = peg$c82;
                                        peg$currPos++;
                                    } else {
                                        s0 = peg$FAILED;
                                        if (peg$silentFails === 0) { peg$fail(peg$c83); }
                                    }
                                    if (s0 === peg$FAILED) {
                                        if (input.charCodeAt(peg$currPos) === 73) {
                                            s0 = peg$c84;
                                            peg$currPos++;
                                        } else {
                                            s0 = peg$FAILED;
                                            if (peg$silentFails === 0) { peg$fail(peg$c85); }
                                        }
                                        if (s0 === peg$FAILED) {
                                            if (input.charCodeAt(peg$currPos) === 74) {
                                                s0 = peg$c86;
                                                peg$currPos++;
                                            } else {
                                                s0 = peg$FAILED;
                                                if (peg$silentFails === 0) { peg$fail(peg$c87); }
                                            }
                                            if (s0 === peg$FAILED) {
                                                if (input.charCodeAt(peg$currPos) === 75) {
                                                    s0 = peg$c88;
                                                    peg$currPos++;
                                                } else {
                                                    s0 = peg$FAILED;
                                                    if (peg$silentFails === 0) { peg$fail(peg$c89); }
                                                }
                                                if (s0 === peg$FAILED) {
                                                    if (input.charCodeAt(peg$currPos) === 76) {
                                                        s0 = peg$c90;
                                                        peg$currPos++;
                                                    } else {
                                                        s0 = peg$FAILED;
                                                        if (peg$silentFails === 0) { peg$fail(peg$c91); }
                                                    }
                                                    if (s0 === peg$FAILED) {
                                                        if (input.charCodeAt(peg$currPos) === 77) {
                                                            s0 = peg$c92;
                                                            peg$currPos++;
                                                        } else {
                                                            s0 = peg$FAILED;
                                                            if (peg$silentFails === 0) { peg$fail(peg$c93); }
                                                        }
                                                        if (s0 === peg$FAILED) {
                                                            if (input.charCodeAt(peg$currPos) === 80) {
                                                                s0 = peg$c94;
                                                                peg$currPos++;
                                                            } else {
                                                                s0 = peg$FAILED;
                                                                if (peg$silentFails === 0) { peg$fail(peg$c95); }
                                                            }
                                                            if (s0 === peg$FAILED) {
                                                                if (input.charCodeAt(peg$currPos) === 81) {
                                                                    s0 = peg$c96;
                                                                    peg$currPos++;
                                                                } else {
                                                                    s0 = peg$FAILED;
                                                                    if (peg$silentFails === 0) { peg$fail(peg$c97); }
                                                                }
                                                                if (s0 === peg$FAILED) {
                                                                    if (input.charCodeAt(peg$currPos) === 82) {
                                                                        s0 = peg$c98;
                                                                        peg$currPos++;
                                                                    } else {
                                                                        s0 = peg$FAILED;
                                                                        if (peg$silentFails === 0) { peg$fail(peg$c99); }
                                                                    }
                                                                    if (s0 === peg$FAILED) {
                                                                        if (input.charCodeAt(peg$currPos) === 83) {
                                                                            s0 = peg$c100;
                                                                            peg$currPos++;
                                                                        } else {
                                                                            s0 = peg$FAILED;
                                                                            if (peg$silentFails === 0) { peg$fail(peg$c101); }
                                                                        }
                                                                        if (s0 === peg$FAILED) {
                                                                            if (input.charCodeAt(peg$currPos) === 84) {
                                                                                s0 = peg$c102;
                                                                                peg$currPos++;
                                                                            } else {
                                                                                s0 = peg$FAILED;
                                                                                if (peg$silentFails === 0) { peg$fail(peg$c103); }
                                                                            }
                                                                            if (s0 === peg$FAILED) {
                                                                                if (input.charCodeAt(peg$currPos) === 88) {
                                                                                    s0 = peg$c104;
                                                                                    peg$currPos++;
                                                                                } else {
                                                                                    s0 = peg$FAILED;
                                                                                    if (peg$silentFails === 0) { peg$fail(peg$c105); }
                                                                                }
                                                                                if (s0 === peg$FAILED) {
                                                                                    if (input.charCodeAt(peg$currPos) === 89) {
                                                                                        s0 = peg$c106;
                                                                                        peg$currPos++;
                                                                                    } else {
                                                                                        s0 = peg$FAILED;
                                                                                        if (peg$silentFails === 0) { peg$fail(peg$c107); }
                                                                                    }
                                                                                    if (s0 === peg$FAILED) {
                                                                                        if (input.charCodeAt(peg$currPos) === 90) {
                                                                                            s0 = peg$c108;
                                                                                            peg$currPos++;
                                                                                        } else {
                                                                                            s0 = peg$FAILED;
                                                                                            if (peg$silentFails === 0) { peg$fail(peg$c109); }
                                                                                        }
                                                                                        if (s0 === peg$FAILED) {
                                                                                            if (input.charCodeAt(peg$currPos) === 85) {
                                                                                                s0 = peg$c110;
                                                                                                peg$currPos++;
                                                                                            } else {
                                                                                                s0 = peg$FAILED;
                                                                                                if (peg$silentFails === 0) { peg$fail(peg$c111); }
                                                                                            }
                                                                                            if (s0 === peg$FAILED) {
                                                                                                if (input.charCodeAt(peg$currPos) === 86) {
                                                                                                    s0 = peg$c112;
                                                                                                    peg$currPos++;
                                                                                                } else {
                                                                                                    s0 = peg$FAILED;
                                                                                                    if (peg$silentFails === 0) { peg$fail(peg$c113); }
                                                                                                }
                                                                                                if (s0 === peg$FAILED) {
                                                                                                    if (input.charCodeAt(peg$currPos) === 87) {
                                                                                                        s0 = peg$c114;
                                                                                                        peg$currPos++;
                                                                                                    } else {
                                                                                                        s0 = peg$FAILED;
                                                                                                        if (peg$silentFails === 0) { peg$fail(peg$c115); }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return s0;
        }


        var buildTree = function(first, rest) {
            if(rest.length == 0) {
                return first;
            } else {
                var next = rest.shift();
                var operator = next[0]
                var term = next[1]
                return {left: first, right: buildTree(term, rest), op: operator};
            }
        }


        peg$result = peg$startRuleFunction();

        if (peg$result !== peg$FAILED && peg$currPos === input.length) {
            return peg$result;
        } else {
            if (peg$result !== peg$FAILED && peg$currPos < input.length) {
                peg$fail({ type: "end", description: "end of input" });
            }

            throw peg$buildException(
                        null,
                        peg$maxFailExpected,
                        peg$maxFailPos < input.length ? input.charAt(peg$maxFailPos) : null,
                                                        peg$maxFailPos < input.length
                                                        ? peg$computeLocation(peg$maxFailPos, peg$maxFailPos + 1)
                                                        : peg$computeLocation(peg$maxFailPos, peg$maxFailPos)
                        );
        }
    }

    return {
        SyntaxError: peg$SyntaxError,
        parse:       peg$parse
    };
})();


function GCodeParser(gcode){
    this.formatedGCode = "";
    this.parsedGCode = [];
    this.gcodeScrubber = function(s, enc){
        var in_comment = false;
        for(var result = [], i=0, j=0; i<s.length; i++) {
            var c = s[i];
            var keep_result = true;
            switch(c) {
            case ' ':
            case '\t':
                keep_result = false;
                break;
            case '(':
                if(in_comment) {
                    // ERROR
                } else {
                    in_comment = true;
                    keep_result=false;
                }
                break;
            case ')':
                if(in_comment) {
                    in_comment = false;
                    keep_result=false;
                } else {
                    // ERROR
                }
                break;
            default:
                if(in_comment) { keep_result = false;}
                break;
            }
            if(keep_result) {
                result[j++] = c;
            }
        }
        var output = result.join('');
        return output;
    };

    this.init = function(){
        this.formatedGCode = this.gcodeScrubber(gcode);
        var lines = this.formatedGCode.split(/[\r]*\n/g);
        var re = /^[A-Za-z]/;
        try{
            for(var i = 0, len = lines.length; i < len; ++i){
                if(re.test(lines[i])){
                    this.parsedGCode.push(gcodeLineParser.parse(lines[i]));
                }
            }
        }catch(e){
            console.log(JSON.stringify(e));
        }
    };
    this.init();
}

var GCodeInterpreter = {
    createNew:function(options){
        var interpreter = {}
//        interpreter._ = function(cdm, args){ return;}
        interpreter._exec = function(cmd, args){
            if((cmd in this) && (typeof this[cmd] == 'function')) {
                //                var f = this[cmd].bind(this);
                return this[cmd](args);
            } else {
                return this._(cmd, args);
            }
        }

        interpreter._handle_line = function(line){
            var args = {};
            var gCMDs = [];
            var words = line.words;
            for(var i = 0, len = words.length; i < len; ++i){
                var word = words[i];
                var letter = word[0];
                var arg = word[1];
                switch(letter) {
                case 'G':
                case 'M':
                    gCMDs.push(letter + arg);
                    break;
                default:
                    args[letter] = arg;
                    break;
                }
            }
            if(gCMDs.length == 0){
                interpreter._NoCmd(args);
            }

            for(i = 0; i < gCMDs.length; ++i){
                interpreter._exec(gCMDs[i], args);
            }
        };

        interpreter.interprete = function(gcode){
            var gcodeParser = new GCodeParser(gcode);
            for(var i = 0, lines = gcodeParser.parsedGCode, len = lines.length; i < len; ++i){
                interpreter._handle_line(lines[i]);
            }
        }
        return interpreter;
    }

}
