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
end
