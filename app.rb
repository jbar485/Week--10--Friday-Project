require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/author')
require('pry')
require("pg")
require('./lib/patron')

also_reload('lib/**/*.rb')
