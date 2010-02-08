/*
 * Dynamic Table of Contents script
 * by Matt Whitlock <http://www.whitsoftdev.com/>
 * Modded by mims wright
 */

function createLink(href, innerHTML) {
	var a = document.createElement("a");
	a.setAttribute("href", href);
	a.innerHTML = innerHTML;
	return a;
}

function generateTOC(toc, body) {
	var i2 = 0, i3 = 0, i4 = 0;
	toc = document.getElementById(toc);
	toc.style.display = "none";
	toc = toc.appendChild(document.createElement("ul"));
	body = document.getElementById(body);
	for (var i = 0; i < body.childNodes.length; ++i) {
		var node = body.childNodes[i];
		var tagName = node.nodeName.toLowerCase();
		if (tagName == "h4") {
			++i4;
			if (i4 == 1) toc.lastChild.lastChild.lastChild.appendChild(document.createElement("ul"));
			var section = i2 + "." + i3 + "." + i4;
			node.insertBefore(document.createTextNode(section + ". "), node.firstChild);
			node.id = "section" + section;
			toc.lastChild.lastChild.lastChild.lastChild.appendChild(document.createElement("li")).appendChild(createLink("#section" + section, node.innerHTML));
		}
		else if (tagName == "h3") {
			++i3, i4 = 0;
			if (i3 == 1) toc.lastChild.appendChild(document.createElement("ul"));
			var section = i2 + "." + i3;
			node.insertBefore(document.createTextNode(section + ". "), node.firstChild);
			node.id = "section" + section;
			toc.lastChild.lastChild.appendChild(document.createElement("li")).appendChild(createLink("#section" + section, node.innerHTML));
		}
		else if (tagName == "h2") {
			++i2, i3 = 0, i4 = 0;
			var section = i2;
			node.insertBefore(document.createTextNode(section + ". "), node.firstChild);
			node.id = "section" + section;
			toc.appendChild(h2item = document.createElement("li")).appendChild(createLink("#section" + section, node.innerHTML));
		}
	}
}

function toggleTOC(toc, button) {
	toc = document.getElementById(toc);
	if (toc.style.display == "block" || toc.style.display == "") {
		toc.style.display = "none";
		button.value = "Show Table of Contents"
	} else {
		toc.style.display = "block";
		button.value = "Hide Table of Contents"
	}
}