(function() {

  $(document).ready(function() {
    var getNext, getPre, resizer;
    getNext = function(elm) {
      var next;
      next = elm.next();
      if (!next.length) {
        return elm;
      }
      if (next.position().top !== elm.position().top) {
        return elm;
      } else {
        return getNext(next);
      }
    };
    getPre = function(elm) {
      var pre;
      pre = elm.prev();
      if (!pre.length) {
        return elm;
      }
      if (pre.position().top !== elm.position().top) {
        return elm;
      } else {
        return getPre(pre);
      }
    };
    $(".box").on("click", function(event) {
      var box, obj, pre;
      $(".box").removeClass("active");
      box = $(event.currentTarget);
      box.addClass("active");
      console.log(box);
      pre = getNext(box);
      obj = $("#box-view");
      return obj.slideUp("fast", function() {
        return $('html, body').animate({}, "fast", function() {
          obj.insertAfter(pre);
          return obj.slideDown("fast");
        });
      });
    });
    return resizer = null;
    /*
    ref = $(".swipe")
    console.log ref
    if ref.length
      for elm in ref
        new SwipeManager(elm)
    */

  });

}).call(this);
