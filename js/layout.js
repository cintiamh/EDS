// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var ListView, listView;
    ListView = (function(_super) {

      __extends(ListView, _super);

      function ListView() {
        return ListView.__super__.constructor.apply(this, arguments);
      }

      ListView.prototype.el = $('p');

      ListView.prototype.initialize = function() {
        _.bindAll(this);
        return this.render();
      };

      ListView.prototype.render = function() {
        return $(this.el).append('<ul><li>Hello, Backbone!</li></ul>');
      };

      return ListView;

    })(Backbone.View);
    return listView = new ListView;
  });

}).call(this);
