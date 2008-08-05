class Page
  attr_accessor :queries

  BASE_URL = 'http://boomdesigngroup.lighthouseapp.com'

  def initialize
    @queries = Array.new
  end

  def add_query(query)
    @queries << query
  end

  def get_binding
    binding
  end
end

class Ticket
  attr_accessor :attributes, :project, :milestone

  def initialize(attributes, project, milestone)
    @attributes = attributes
    @project = project
    @milestone = milestone
  end
end