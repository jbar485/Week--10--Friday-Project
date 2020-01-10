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

get("/projects/new") do
  erb(:new_project)
end

post('/projects') do
  title = params[:project_title]
  project = Project.new({:title => title, :id => nil})
  project.save()
  @projects = Project.sorted
  erb(:projects)
end

get('/projects/destroy') do
  Project.clear
  redirect to('/projects')
end
