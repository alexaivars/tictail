(function() {
  var FlexBox, SlideMenu, Teaser, hover, _ref;

  if ((_ref = window.console) == null) {
    window.console = {
      log: function() {}
    };
  }

  /*
  (->
    lastTime = 0
    vendors = ["ms", "moz", "webkit", "o"]
    x = 0
  
    while x < vendors.length and not window.requestAnimationFrame
      window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
      window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
      ++x
    unless window.requestAnimationFrame
      window.requestAnimationFrame = (callback, element) ->
        currTime = new Date().getTime()
        timeToCall = Math.max(0, 16 - (currTime - lastTime))
        id = window.setTimeout(->
          callback currTime + timeToCall
        , timeToCall)
        lastTime = currTime + timeToCall
        id
    unless window.cancelAnimationFrame
      window.cancelAnimationFrame = (id) ->
        clearTimeout id
  )()
  */


  hover = function(event) {
    return event.data.toggleClass("hover", event.type === "touch");
  };

  $(document).ready(function() {
    console.log("\\(x.×)/we are kramgo\\(x.×)/");
    console.log("-----^*_lopiloopilopi_*^-----");
    console.log("Copyright Alexander Aivars");
    return $("img").on("dragstart", function() {
      return false;
    });
    /* 
    mySwipe = new Swipe(document.getElementById("slider"),
      continuous: true
      disableScroll: false
      stopPropagation: false
      auto: 0
      delay: 100
    )
    
    if Modernizr.touch
      ref = $(".teaser")
      if ref.length
        for elm in ref
          j = $(elm)
          j.on "touch tap release", j,  (event) ->
            requestAnimationFrame (event) => hover(event) 
            if (event.type == "tap")
              j.find("a")[0].click()
    
    ref = $("X.product-teaser")
    teaser = null
    if ref.length
      for elm in ref
        unless teaser
          teaser = new Teaser()
        teaser.add($(elm))
    if teaser then teaser.draw()
    
    ref = $(".jsFlexbox")
    if ref.length
      for elm in ref
        flexbox = new FlexBox($(elm))
        flexbox.draw()
        flexbox = null
    
    new SlideMenu $("#container"), $("#nav"), $("#content")
    */

  });

  SlideMenu = (function() {

    function SlideMenu(container, menu, content) {
      var _this = this;
      this.container = container;
      this.menu = menu;
      this.content = content;
      this.width = this.menu.width();
      this.touch = Hammer(this.container[0]);
      this.delta = 0;
      this.dragX = 0;
      this.touch.on("touch dragleft dragright swipeleft swiperight release", function(event) {
        return _this.touchHandler(event);
      });
      Hammer($("[data-action=menu-toggle]")[0]).on("tap", function(event) {
        return _this.toggle(event);
      });
      return;
    }

    SlideMenu.prototype.touchHandler = function(event) {
      switch (event.type) {
        case "touch":
          this.delta = this.dragX;
          this.container.removeClass("animate");
          break;
        case "dragright":
        case "dragleft":
          event.gesture.preventDefault();
          this.setOffset(Math.max(0, Math.min(this.width, event.gesture.deltaX + this.delta)));
          break;
        case "swiperight":
          this.setOffset(this.width, true);
          break;
        case "swipeleft":
          this.setOffset(0, true);
          break;
        case "release":
          if (this.dragX > this.width * 0.5) {
            this.setOffset(this.width, true);
          } else {
            this.setOffset(0, true);
          }
      }
    };

    SlideMenu.prototype.toggle = function(event) {
      event.preventDefault();
      event.gesture.preventDefault();
      if (this.dragX > this.width * 0.5) {
        this.setOffset(0, true);
      } else {
        this.setOffset(this.width, true);
      }
    };

    SlideMenu.prototype.setOffset = function(px, animate) {
      this.dragX = px;
      this.container.toggleClass("animate", animate);
      if (Modernizr.csstransforms3d) {
        return this.container.css("transform", "translate3d(" + px + "px, 0, 0) scale3d(1,1,1)");
      } else if (Modernizr.csstransforms) {
        return this.container.css("transform", "translate(" + px + "px, 0)");
      } else {
        return this.container.css("left", "" + px + "px");
      }
    };

    return SlideMenu;

  })();

  FlexBox = (function() {

    function FlexBox(container) {
      var elm, _i, _len, _ref1,
        _this = this;
      this.container = container;
      this.boxes = [];
      _ref1 = this.container.children();
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        elm = _ref1[_i];
        this.boxes.push($(elm));
      }
      $(window).on("resize", function(event) {
        return _this.draw();
      });
      return;
    }

    FlexBox.prototype.draw = function() {
      var box, h, val, _i, _j, _len, _len1, _ref1, _ref2;
      h = 0;
      _ref1 = this.boxes;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        box = _ref1[_i];
        val = box.height('auto').height();
        if (val > h) {
          h = val;
        }
      }
      _ref2 = this.boxes;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        box = _ref2[_j];
        box.height(h);
      }
    };

    return FlexBox;

  })();

  Teaser = (function() {

    function Teaser(container) {
      var _this = this;
      this.container = container;
      this.refs = [];
      $(window).on("resize", function(event) {
        return _this.draw();
      });
      return;
    }

    Teaser.prototype.add = function(elm) {
      var _this = this;
      this.refs.push($(elm));
      elm.on("click", function(event) {
        return _this.clicked(event, elm);
      });
    };

    Teaser.prototype.draw = function() {
      var heading, ref, _i, _len, _ref1;
      _ref1 = this.refs;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        ref = _ref1[_i];
        heading = $(ref).find("heading");
        if (heading.length) {
          this.layoutHeading(heading[0]);
        }
      }
    };

    Teaser.prototype.layoutHeading = function(elm) {
      var child, total, y, _i, _j, _len, _len1, _ref1, _ref2;
      total = 0;
      _ref1 = elm.children;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        child = _ref1[_i];
        total += child.offsetHeight;
      }
      y = (elm.parentNode.offsetHeight - total) * 0.5;
      _ref2 = elm.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        child = _ref2[_j];
        child.style.position = "absolute";
        child.style.top = "" + y + "px";
        y += child.offsetHeight;
      }
    };

    Teaser.prototype.clicked = function(event, elm) {
      if (event.target.nodeName.toLowerCase() !== "a") {
        elm.find("a")[0].click();
      }
    };

    return Teaser;

  })();

}).call(this);
