.pragma library

function cloneObject(ob) {
    return JSON.parse(JSON.stringify(ob));
}
