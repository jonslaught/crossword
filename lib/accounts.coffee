if Meteor.isServer

  Accounts.onCreateUser (opt, user) ->

    if user.services.facebook
      opt.profile.picture = "http://graph.facebook.com/#{user.services.facebook.id}/picture/?type=large"

    if user.services.google
      opt.profile.picture = user.services.google.picture

    user.profile = opt.profile
    return user


  ServiceConfiguration.configurations.remove
    service: 'facebook'

  ServiceConfiguration.configurations.insert
    service: 'facebook'
    appId: '1436425333290403'
    secret: 'f806dbbf3e2a257ecf4dfa396f60490b'

  ServiceConfiguration.configurations.remove
    service: 'google'

  ServiceConfiguration.configurations.insert
    service: 'google'
    clientId: '582377249744-m188gc3vheafeds3n30d7is4sidv8pnu.apps.googleusercontent.com'
    secret: 'V-RlpBvfFrdHXy7GiY9SnPxM'