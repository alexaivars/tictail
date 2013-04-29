(function() {
  var DATA_NAME, inView, lazy_list, _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  "use strict";

  DATA_NAME = "data-src";

  lazy_list = [];

  inView = function(elm, height) {
    var offsetParent, rect;
    offsetParent = elm.offsetParent;
    rect = elm.parentNode.getBoundingClientRect();
    if (rect.top === 0) {
      if (offsetParent) {
        return rect = offsetParent.getBoundingClientRect();
      } else {
        return false;
      }
    } else {
      return rect.top >= 0 && rect.top <= height || rect.bottom >= 0 && rect.bottom <= height;
    }
  };

  krmg.LazyImage = {
    init: function() {
      var img, node, _i, _len;
      node = document.getElementsByTagName("img");
      for (_i = 0, _len = node.length; _i < _len; _i++) {
        img = node[_i];
        if (img.getAttribute(DATA_NAME) != null) {
          lazy_list.push(img);
        }
      }
      return this;
    },
    load: function() {
      var height, img, update, _i, _j, _len, _len1;
      height = window.innerHeight || document.documentElement.clientHeight;
      update = [];
      for (_i = 0, _len = lazy_list.length; _i < _len; _i++) {
        img = lazy_list[_i];
        if (inView(img, height)) {
          update.push(img);
        }
      }
      for (_j = 0, _len1 = update.length; _j < _len1; _j++) {
        img = update[_j];
        this.get(img);
      }
      return this;
    },
    get: function(elm, notween) {
      var src;
      src = elm.getAttribute(DATA_NAME);
      if (elm.src !== src) {
        elm.src = src;
      }
      /*
      img.onload = ->
        elm.getAttribute(DATA_NAME)
        lazy_list.splice(lazy_list.indexOf(elm), 1) if Array::indexOf
        if elm.parentNode?
          elm.parentNode.replaceChild img, elm
        else
          elm.className = ""
          elm.removeAttribute(DATA_NAME)
          elm.src = src
        unless notween
          try
            TweenLite.from elm, 0.25,
              opacity : 0
          catch e
            console.log "missing TweenLite"
      */

      return this;
    }
  };

}).call(this);
