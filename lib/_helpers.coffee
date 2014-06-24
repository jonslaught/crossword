@_ = lodash

@log = (stuff...) ->
  console.log(stuff...)

@prettify = (stuff) ->
  JSON.stringify(stuff,null,2)

# jQuery

@bounds = (elt) ->
  p = $(elt).position()
  return {
    top: p.top
    left: p.left
    right: p.left + $(elt).width()
    bottom: p.top + $(elt).height() 
    height: $(elt).height()
    width: $(elt).width()
  }

# Models
_.extend Meteor.Collection.prototype,
  findOrInsert: (obj) -> @findOne(obj) ? @findOne(@insert(obj))

_.extend Meteor.Collection.prototype,
  upsert: (selector, modifier) ->
    doc = @findOrInsert(selector)
    @update doc._id, modifier