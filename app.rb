require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})
also_reload('lib/**/*.rb')

get("/") do
  erb(:main_page)
end

get('/projects') do
  if params[:search]
    @projects = Project.search(params[:search])
  else
    @projects = Project.sorted
  end
  erb(:projects)
end

get("/projects/new") do
  erb(:new_project)
end

post("/projects") do
  title = params[:project_title]
  project = Project.new({:title => title, :id => nil})
  project.save()
  @projects = Project.sorted
  erb(:projects)
end

get("/projects/destroy") do
  Project.destroy
  redirect to('/projects')
end

get("/projects/:id") do
  @project = Project.find(params[:id].to_i())
  erb(:project)
end

get("/projects/:id/edit") do
  @project = Project.find(params[:id].to_i())
  erb(:edit_project)
end

patch("/projects/:id") do
  @project = Project.find(params[:id].to_i())
  @project.update(params[:project_title])
  redirect to('/projects')
end

delete("/projects/:id") do
  @project = Project.find(params[:id].to_i())
  @project.delete()
  redirect to('/projects')
end

post("/projects/:id/volunteers") do
  @project = Project.find(params[:id].to_i())
  volunteer = Volunteer.new({:name => params[:volunteer_name], :project_id => @project.id, :id => nil})
  volunteer.save()
  erb(:project)
end
