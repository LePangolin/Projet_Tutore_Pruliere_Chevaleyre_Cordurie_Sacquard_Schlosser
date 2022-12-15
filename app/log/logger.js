const fs = require('fs');

/**
 * Fonction qui permet de créer un log
 * @param {String} logName 
 * @param {String} logContent 
 * @param {String} logType
 * @returns {void}
 * @example createLog("database", "Table users created", "info") 
 */
function createLog(logName, logContent, logType){
    let content = "";
    switch(logType){
        case "info":
            content = "[INFO] " + logContent;
            break;
        case "error":
            content = "[ERROR] " + logContent;
            break;
        case "warning":
            content = "[WARNING] " + logContent;
            break;
        default:
            content = "[INFO] " + logContent;
            break;
    }
    fs.appendFile("./log/logs/"+ logName +".log", content + " " + new Date() + " \r \n", function (err) {
        if (err) throw err;
    });
}

module.exports = {
    createLog
}