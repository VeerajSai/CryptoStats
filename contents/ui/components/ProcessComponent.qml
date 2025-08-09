import QtQuick

QtObject {
    property string command: ""
    property var onFinished: null
    
    function start() {
        if (!command) return;
        
        // For KDE Plasma, we'll use a different approach since direct process execution
        // is restricted. We'll fall back to XMLHttpRequest implementation.
        if (onFinished) {
            onFinished("", 1); // Signal failure to trigger fallback
        }
    }
}
