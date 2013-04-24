(function() {
  var removeToInsertLater, wash;

  removeToInsertLater = function(element) {
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
  };

  wash = function(element) {
    var child, _i, _len, _ref;
    element.removeAttribute("style");
    if (element.children.length) {
      _ref = element.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        wash(child);
      }
    }
    return element;
  };

  $(document).ready(function() {
    var element, insert, ref, _i, _len;
    ref = $(".html_content");
    if (ref.length) {
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        element = ref[_i];
        insert = removeToInsertLater(element);
        wash(element);
        element.className = element.className.replace(/html_content\s*/, "");
        insert();
      }
    }
  });

}).call(this);
