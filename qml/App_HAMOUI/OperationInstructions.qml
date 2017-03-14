import QtQuick 1.1
import Extentui 1.0
import QtWebKit 1.0

import "./Theme.js" as Theme
import "ShareData.js" as ShareData
import "../ICCustomElement"

ICInstructionsView {
    width: 800
    height: 400
}
//ICFlickable{
//    id:webView
//    width: 700
//    height: 400
//    contentWidth:view.width
//    contentHeight: view.height
//    isshowhint: true
//    flickableDirection: Flickable.VerticalFlick
//    function fixUrl(url)
//    {
//        if (url == "") return url
//        if (url[0] == "/") return "file://"+url
//        if (url.indexOf(":")<0) {
//            if (url.indexOf(".")<0 || url.indexOf(" ")>=0) {
//                // Fall back to a search engine; hard-code Wikipedia
//                return "http://en.wikipedia.org/w/index.php?search="+url
//            } else {
//                return "http://"+url
//            }
//        }
//        return url
//    }
//    WebView{
//        id:view
////        width: 700
////        height: 400
//            preferredWidth: 700
//            preferredHeight: 400
////        url: "file:///home/xs/workspace_v6_1/PanelRobot/bin_1.0.1_debug/Instructions/HC-S6-V2.4.htm"

//            url: fixUrl("file:///home/xs/workspace_v6_1/PanelRobot/bin_1.0.1_debug/Instructions/HC-S6-V2.4.htm")
////            url: fixUrl("https://www.baidu.com")
//        onUrlChanged: {
//            console.log(url);
////            url="file:///home/xs/workspace_v6_1/PanelRobot/bin_1.0.1_debug/Instructions/HC-S6-V2.4.htm#_Toc25608"
//        }
//    }
//}
