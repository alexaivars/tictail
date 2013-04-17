(function() {
  var addEventListener, images, inView, load, pending, processScroll;

  images = $("img.lazy").toArray();

  pending = false;

  load = function(elm, express) {
    var img, src;
    img = new Image();
    src = elm.getAttribute("data-src");
    img.onload = function() {
      if (!!elm.parent) {
        elm.parent.replaceChild(img, elm);
      } else {
        elm.src = src;
      }
      if (!express) {
        return TweenLite.from(elm, 0.25, {
          opacity: 0
        });
      }
    };
    return img.src = src;
  };

  inView = function(elm) {
    var height, rect;
    rect = elm.parentNode.getBoundingClientRect();
    height = window.innerHeight || document.documentElement.clientHeight;
    return rect.top >= 0 && rect.top <= height || rect.bottom >= 0 && rect.bottom <= height;
  };

  addEventListener = function(event, fn) {
    if (window.addEventListener) {
      return this.addEventListener(event, fn, false);
    } else {
      if (window.attachEvent) {
        return this.attachEvent("on" + event, fn);
      } else {
        return this["on" + event] = fn;
      }
    }
  };

  processScroll = function(express) {
    var img, queue, _i, _j, _len, _len1, _results;
    if (!(pending || images.length)) {
      return;
    }
    queue = [];
    pending = false;
    for (_i = 0, _len = images.length; _i < _len; _i++) {
      img = images[_i];
      if (inView(img)) {
        queue.push(img);
      }
    }
    _results = [];
    for (_j = 0, _len1 = queue.length; _j < _len1; _j++) {
      img = queue[_j];
      images.splice(images.indexOf(img), 1);
      _results.push(load(img, express));
    }
    return _results;
  };

  processScroll();

  addEventListener("resize", function() {
    pending = true;
    return requestAnimationFrame(function() {
      return processScroll();
    });
  });

  addEventListener("scroll", function() {
    pending = true;
    return requestAnimationFrame(function() {
      return processScroll();
    });
  });

}).call(this);
