Qt.include("../../utils/HashTable.js")

var itemToEditorMap = new HashTable();
var configNameWidth = 120;
var inputWidth = 100;
var editingActionObject;
var editorToItemMap = new HashTable();
var editingEditors = [];
var registerEditors = [];

function isRegisterEditor(editor){
    for(var i = 0, len = registerEditors.length; i < len; ++i){
        if(editor === registerEditors[i])
            return true;
    }
    return false;
}
