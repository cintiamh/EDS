class ListView extends Backbone.View
  el: $ 'p'

  initialize: ->
    _.bindAll @
    @render()

  render: ->
    $(@el).append '<ul><li>Hello, Backbone!</li></ul>'

listView = new ListView

