(function() {
  var SelectLable;

  $(document).ready(function() {
    var elm, instance, ref, _i, _len, _results;
    ref = $(".variations_select_label");
    if (ref.length) {
      _results = [];
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        elm = ref[_i];
        _results.push(instance = new SelectLable(elm));
      }
      return _results;
    }
  });

  SelectLable = (function() {

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
      var _this = this;
      this.select.on('change', function(event) {
        return _this.changed();
      });
      this.changed();
    };

    SelectLable.prototype.changed = function() {
      var $elm;
      try {
        $elm = $(this.select[0].options[this.select[0].selectedIndex]);
        return this.label.html($elm[0].innerHTML);
      } catch (e) {
        return console.log(e);
      }
    };

    return SelectLable;

  })();

}).call(this);
