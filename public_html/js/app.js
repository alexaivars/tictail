(function() {

  Sammy(function() {
    this.get('/products', function() {
      console.log("list all products");
    });
    this.get(/\#\/products\/(.*)/, function() {
      console.log("list " + this.params['splat'] + " products");
    });
    this.get(/\#\/product\/(.*)/, function() {
      console.log("show product " + this.params['splat']);
    });
    this.get(/\#\/(.*)/, function() {
      console.log("show other " + this.params['splat']);
    });
    return this.get('', function() {
      console.log("show default");
    });
  }).run();

}).call(this);
