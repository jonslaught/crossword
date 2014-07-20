@_ = lodash

@log = (stuff...) ->
  console.log(stuff...)

@prettify = (stuff) ->
  JSON.stringify(stuff,null,2)

# jQuery

@bounds = (elt) ->
  p = $(elt).position()
  if p
    return {
      top: p.top
      left: p.left
      right: p.left + $(elt).width()
      bottom: p.top + $(elt).height() 
      height: $(elt).height()
      width: $(elt).width()
    }
  else
    return {
      top: 0
      left: 0
      right: 0
      bottom: 0
      height: 0
      width: 0
    }

# Models
_.extend Meteor.Collection.prototype,
  findOrInsert: (obj) -> @findOne(obj) ? @findOne(@insert(obj))

_.extend Meteor.Collection.prototype,
  upsert: (selector, modifier) ->
    doc = @findOrInsert(selector)
    @update doc._id, modifier
    return @findOne(doc._id)

UI.registerHelper "formatDate", (date, format) ->
  if date? and format?
    date = moment(date)
    date.lang('en')
    date.format(format)