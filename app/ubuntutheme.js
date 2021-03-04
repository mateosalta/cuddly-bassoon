
    // Override video element canPlayType() function
    var videoElem = document.createElement('video');
    var origCanPlayType = videoElem.canPlayType.bind(videoElem);
    videoElem.__proto__.canPlayType = function (type) {
        if (type === undefined) return '';
        // If queried about webM/vp8/vp8 support, say we don't support them
        if (type.indexOf('webm') != -1
            || type.indexOf('vp8') != -1
            || type.indexOf('vp9') != -1) {
            return '';
        }
        // Otherwise, ask the browser
        return origCanPlayType(type);
    }
    
    // Override media source extension isTypeSupported() function
    var mse = window.MediaSource;
    var origIsTypeSupported = mse.isTypeSupported.bind(mse);
    mse.isTypeSupported = function (type) {
        if (type === undefined) return '';
        // If queried about webM/vp8/vp8 support, say we don't support them
        if (type.indexOf('webm') != -1
            || type.indexOf('vp8') != -1
            || type.indexOf('vp9') != -1) {
            return '';
        }
        // Otherwise, ask the browser
        return origIsTypeSupported(type);
    }
};
