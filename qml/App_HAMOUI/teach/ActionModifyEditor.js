Qt.include("../../utils/HashTable.js")

var itemToEditorMap = new HashTable();
var configNameWidth = 80;
var inputWidth = 100;
var editingActionObject;
var editorToItemMap = new HashTable();
var editingEditors = [];