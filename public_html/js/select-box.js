(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.SelectLable = (function() {
    SelectLable.prototype.prefix = '';

    function SelectLable(element) {
      this.label = (element instanceof jQuery ? element : $(element));
      this.select = this.label.prev();
      if (!this.select.hasClass("tictail_variations_select")) {
        this.label = null;
        this.select = null;
        return;
      }
      this.setup();
      this;
    }

    SelectLable.prototype.setup = function() {
      var html, index, opt, _i, _len, _ref1,
        _this = this;

      this.select.on('change', function(event) {
        return _this.changed();
      });
      this.options = $("<div class='variations_option_container'>");
      this.options.on("click", function(event) {
        _this.select[0].selectedIndex = event.target.getAttribute("data-index");
        _this.changed();
        return _this.options.slideToggle("fast");
      });
      html = "";
      _ref1 = this.select[0].options;
      for (index = _i = 0, _len = _ref1.length; _i < _len; index = ++_i) {
        opt = _ref1[index];
        html += "<div class='variations_option' data-index='" + index + "'>" + opt.innerHTML + "</div>";
      }
      this.options[0].innerHTML = html;
      this.label.after(this.options);
      this.label.on("click", function(event) {
        return _this.options.slideToggle("fast");
      });
      this.changed();
    };

    SelectLable.prototype.changed = function() {
      var $elm, e;

      try {
        $elm = $(this.select[0].options[this.select[0].selectedIndex]);
        return this.label.html($elm[0].innerHTML);
      } catch (_error) {
        e = _error;
        return console.log(e);
      }
    };

    return SelectLable;

  })();

}).call(this);
