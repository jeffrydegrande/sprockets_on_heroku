# SprocketsOnHeroku #

This plugin makes sprockets work on heroku, using the same appraoch
[sass_on_heroku][sass] uses for sass. It's pretty much a rack based,
drop in replacement for sprockets-rails.

## Installation

Make sure you have sprockets installed first;
in config/environments.rb

  config.gem 'sprockets'

in .gems

  sprockets

and install the plugin

  script/plugin install git://github.com/jeffrydegrande/sprockets_on_heroku.git

If you want your javascript minified using jsmin, make sure to add it to your .gems as well.

## Configuration
To set a different uri than the default /sprockets.js
create config/initializers/sprockets.rb containing:

  SprocketsOnHeroku.uri = '/custom_uri.js'

## Todo

* no support for assets
* sprockets:install_scripts & sprockets:install_assets are no longer available

[sass]: http://github.com/heroku/sass_on_heroku

Copyright (c) 2009 Jeffry Degrande, released under the MIT license
