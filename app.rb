require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})
also_reload('lib/**/*.rb')

get('/') do
  erb(:main_page)
end

get("/projects") do
  @projects = Project.sorted
  erb(:projects)
end
