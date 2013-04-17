(function() {

  $(document).ready(function() {
    var elm, ref, _i, _len, _results;
    $(".product_slide_figure img").on("dragstart", function(event) {
      event.preventDefault();
      return false;
    });
    ref = $(".product_slide");
    if (ref.length) {
      _results = [];
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        elm = ref[_i];
        if ($(elm).find(".product_slide_figure").length > 1) {
          _results.push(elm.swipe = new Swipe(elm, {
            continuous: true,
            disableScroll: false,
            stopPropagation: false,
            mouse: true,
            auto: 0
          }));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    }
  });

}).call(this);
