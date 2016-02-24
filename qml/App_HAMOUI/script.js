WorkerScript.onMessage = function(message) {
    for(var i = 0 ;i < message.buffer.length;i++){
        message.model.append({"text1": message.buffer[i]});
    }
    message.model.sync();
    WorkerScript.sendMessage({ 'over': true })
}
