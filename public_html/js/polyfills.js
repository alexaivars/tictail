(function() {
  "use strict";
  if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(searchElement) {
      var k, len, n, t;
      if (typeof this === "undefined" || this === null) {
        throw new TypeError();
      }
      t = Object(this);
      len = t.length >>> 0;
      if (len === 0) {
        return -1;
      }
      n = 0;
      if (arguments.length > 1) {
        n = Number(arguments[1]);
        if (n !== n) {
          n = 0;
        } else {
          if (n !== 0 && n !== Infinity && n !== -Infinity) {
            n = (n > 0 || -1) * Math.floor(Math.abs(n));
          }
        }
      }
      if (n >= len) {
        return -1;
      }
      k = (n >= 0 ? n : Math.max(len - Math.abs(n), 0));
      while (k < len) {
        if (k in t && t[k] === searchElement) {
          return k;
        }
        k++;
      }
      return -1;
    };
  }

  (function() {
    var lastTime, vendors, x;
    lastTime = 0;
    vendors = ["ms", "moz", "webkit", "o"];
    x = 0;
    while (x < vendors.length && !window.requestAnimationFrame) {
      window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"];
      window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] || window[vendors[x] + "CancelRequestAnimationFrame"];
      ++x;
    }
    if (!window.requestAnimationFrame) {
      window.requestAnimationFrame = function(callback, element) {
        var currTime, id, timeToCall;
        currTime = new Date().getTime();
        timeToCall = Math.max(0, 16 - (currTime - lastTime));
        id = window.setTimeout(function() {
          return callback(currTime + timeToCall);
        }, timeToCall);
        lastTime = currTime + timeToCall;
        return id;
      };
    }
    if (!window.cancelAnimationFrame) {
      return window.cancelAnimationFrame = function(id) {
        return clearTimeout(id);
      };
    }
  })();

}).call(this);
