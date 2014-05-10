Router.map ->
  @route('counter', {path: '/'})
  @route('admin')

State = new Meteor.Collection 'state'

setState = (props) ->
  state = State.findOne()
  State.update state._id, {$set: props}

incCounter = (amt) ->
  cur = getCounter()
  setState {counter: cur + amt}


if Meteor.isServer
  Meteor.startup ->
    if State.find().count() == 1
      setState {counter: 0}
    else
      State.insert {counter: 0}

else
  getCounter = -> State.findOne()?.counter
  Template.counter.cur = getCounter
  Template.counter.events
    "click button": -> incCounter(1)

  $(window).on 'keydown', (event) ->
    return unless Router.current().route.name is 'admin'
    switch event.which
      when 37 then incCounter(-1)
      when 39 then incCounter(1)
