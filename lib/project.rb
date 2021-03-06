class Project

  attr_accessor :title
  attr_reader :id

  def initialize(attributes)
    @id = attributes.fetch(:id)
    @title = attributes.fetch(:title)
  end

  def ==(other_project)
    if self.title.eql?(other_project.title)
      true
    else
      false
    end
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each() do |project|
      id = project.fetch("id").to_i
      title = project.fetch("title")
      projects.push(Project.new({:id => id, :title => title}))
    end
    projects
  end

  def save()
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    id = project.fetch("id").to_i()
    title = project.fetch("title")
    Project.new({:id => id, :title => title})
  end

  def update(title)
    if title != ""
      @title = title
    end
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
    DB.exec("DELETE FROM volunteers WHERE project_id = #{@id};")
  end

  def self.sorted()
    Project.all.sort_by{ |project| project.title }
  end

  def self.destroy
    DB.exec("DELETE FROM projects *;")
  end

  def self.search(query)
    Project.sorted.select { |project| project.title.match?(/(#{query})/i)}
  end

  def volunteers
    Volunteer.find_by_project(self.id)
  end
end
