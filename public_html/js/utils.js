(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.RE = {
    wash: /<(script|head|style|iframe|frame|noscript)[^\>]*>[\s\S]*?<\/.*?\1>/gi,
    wash: /<(!doctype|head|html|body).*?>/gi,
    wash: /<\/.*?(head|html|body)>/gi,
    wash: /<!--[\s\S]*?-->/gi,
    clean: /^\/\#|^\/|\#|\/\#/
  };

  krmg.HTML = {
    wash: function(html) {
      html = html.replace(krmg.RE.wash1, "");
      html = html.replace(krmg.RE.wash2, "");
      html = html.replace(krmg.RE.wash3, "");
      html = html.replace(krmg.RE.wash4, "");
      return html;
    },
    read: function(html, target) {
      var container, doc;
      html = this.wash(html);
      doc = document;
      if ((document.implementation != null) && (document.implementation.createHTMLDocument != null)) {
        try {
          doc = document.implementation.createHTMLDocument("");
        } catch (e) {
          doc = document;
        }
      }
      container = doc.createElement('div');
      container.innerHTML = html;
      $(target).first().html($(container).find(target).first().html());
      try {
        return TT.store.domReady();
      } catch (e) {
        return console.log("Missing TT.store.domReady");
      }
    }
  };

  krmg.ELEMENT = {
    wash: function(element) {
      var child, _i, _len, _ref1;
      element.removeAttribute("style");
      if (element.children.length) {
        _ref1 = element.children;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          child = _ref1[_i];
          this.wash(child);
        }
      }
      return element;
    },
    insertLater: function(element) {
      var nextSibling, parentNode;
      parentNode = element.parentNode;
      nextSibling = element.nextSibling;
      parentNode.removeChild(element);
      return function() {
        if (nextSibling) {
          return parentNode.insertBefore(element, nextSibling);
        } else {
          return parentNode.appendChild(element);
        }
      };
    }
  };

}).call(this);
