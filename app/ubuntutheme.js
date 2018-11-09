
(function() {
var css = "* {\nfont-family: \"Ubuntu\" !important;\nfont-size: 10pt !important;} \n\n\n ::-webkit-scrollbar { -webkit-appearance: none; width: 0px;} \n\n\n 				\n										@media screen and (orientation:portrait) {\n.html5-video-container{\nposition: fixed !important;\nz-index: 2 !important;\nwidth: auto !important;\nheigth: auto !important;\nbackground-color: #000000 !important;\ntop: 0px !important;\nbox-shadow:0 2px 2px rgba(0,0,0,0.5);\n}\n\nvideo{\nposition: fixed !important;\nz-index: 2 !important;\nwidth: 100% !important;\nheigth: auto !important;\nbackground-color: #000000 !important;\ntop: 0px !important;\nbox-shadow:0 2px 2px rgba(0,0,0,0.5);\n} \n\n .player-container {\nz-index: 1000 !important;\n\ntop: -50px !important;\n\n background: #000000 !important;\n\n}\n} \n\n\n	 @media screen and (orientation:landscape) {\nvideo{\nposition: relative !important;\nz-index: 1000 !important;\nwidth: 100% !important;\nheigth: auto !important;\nbackground-color: #000000 !important;\ntop: 0zpx !important;\nbox-shadow:0 2px 2px rgba(0,0,0,0.5);\n} ytm-single-column-watch-next-results-renderer {\nmargin-top: 40px !important;\n\ntop: -40px !important;\n\n}\n} \n\n\n	 															ytm-header-bar {\nposition: fixed !important;\nwidth: 100% !important;\n\nheigth: auto !important;\nz-index: 1 !important;\noverflow: hidden !important;\n}	 \n\n\n		.searchbox-dropdown {\nposition: fixed !important;\nwidth: 100% !important;\n\nheigth: auto !important;\nz-index: 1000 !important;\noverflow: hidden !important;\n}	 \n\n\n							\n\n 	 \n\n \n\n\n																	} \n\n\n\n\n\n"


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

