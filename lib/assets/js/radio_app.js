//= require libs/jquery
//= require libs/handlebars
//= require libs/emblem
//= require libs/ember
//= require libs/ember-data
//= require_tree .
//= require_self

Radio = Em.Application.create();

Radio.Router.map(function() {
  // put your routes here
});

Radio.IndexRoute = Em.Route.extend({
  model: function() {
    return ['red', 'yellow', 'blue'];
  }
});