
var Theme = function(){
    this.BASE_BG = "#D0D0D0"
    this.MainWindow = {
        topHeaderHeightProportion:0.08,
        containerHeightProportion:0.87,
        middleHeaderHeightProportion:0.05,
        middleHeaderMenuItemWidthProportion: 1/6,
        middleHeaderTI1Proportion:1/8,
        middleHeaderTI2Proportion:0.37,
        width: 800,
        height:600
    }
    this.Content = {
        tipBG : "black",
        tipBorderWidth:3,
        tipBorderBG:"green",
        tipTextColor: "green",
        settingHeightProportion:0.85,
        tipHeightProportion:0.05,
        menuHeightProportion:0.1
    }
    this.TopHeader = {
        menuItemWidthProportion: 0.1,
        menuItemHeightProportion:0.7,
        menuItemBG:"#008300"
    }
    this.TabMenuItem = {
        unCheckedColor:"#A0A0F0",
        checkedColor:this.BASE_BG
    }
    this.LineEdit = {
        borderColor: "gray",
        borderWidth: 1
    }
};

var defaultTheme = new Theme();
