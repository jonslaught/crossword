@_ = lodash

@log = (stuff...) ->
  console.log(stuff...)

@prettify = (stuff) ->
  JSON.stringify(stuff,null,2)

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