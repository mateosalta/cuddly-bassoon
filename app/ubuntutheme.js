
(function() {
var css = "* {\nfont-family: \"Ubuntu\" !important;\nfont-size: 10pt !important;} \n\n\n .mobile-topbar-header { background-color: #ffffff !important;}  .mobile-topbar-header-content { color: #000000 !important; } .html5-video-player { background-color: #ffffff !important } #player-control-overlay { background-color: rgba(255,255,255,0) !important	} #player-control-overlay.fadein  { background-color: rgba(250,250,250,0.6) !important	}  \n\n\n ytm-pivot-bar-renderer {\ndisplay: none !important;}  \n\n\n	@media (prefers-color-scheme: dark) {} \n\n\n	\n\n\n\n\n\n"


;


if (typeof GM_addStyle != "undefined") {
	GM_addStyle(css);
} else if (typeof PRO_addStyle != "undefined") {
	PRO_addStyle(css);
} else if (typeof addStyle != "undefined") {
	addStyle(css);
} else {
	var node = document.createElement("style");
	node.type = "text/css";
	node.appendChild(document.createTextNode(css));
	var heads = document.getElementsByTagName("head");
	if (heads.length > 0) {
		heads[0].appendChild(node); 
	} else {
		// no head yet, stick it whereever
		document.documentElement.appendChild(node);
	}
}

})();
