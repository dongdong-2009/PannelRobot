
var yDefinePageClass;
var curLanguage = "ch";
var perPageCountofY = 16;
var currentTheme;
function finishCreation(){
    var yConfigs = YDefines.yDefines;
    var pageCount = Math.ceil(yConfigs.length / perPageCountofY);
    var ret = [];
    if(yDefinePageClass.status === 3){
        console.log(yDefinePageClass.errorString());
        return;
    }

    for(var i = 0; i < pageCount; ++i){
        var page = yDefinePageClass.createObject(manualContainer,
                                                 {"yDefines":yConfigs.slice(i * perPageCountofY, (i + 1) * perPageCountofY),
                                                   "currentLanguage":curLanguage,
                                                     "color":currentTheme.BASE_BG
                                                 });
        ret.push(page);
        manualContainer.addPage(page)
    }
    manualContainer.setCurrentIndex(0)
}
function generatePages(currentLanguage, theme){
    curLanguage = currentLanguage
    currentTheme = theme;
    yDefinePageClass = Qt.createComponent('YDefinePage.qml');
    if (yDefinePageClass.status == Component.Ready)
        finishCreation();
    else
        yDefinePageClass.statusChanged.connect(finishCreation);
}
