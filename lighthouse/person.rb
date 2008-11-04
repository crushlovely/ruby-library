class Person
  attr_accessor :name, :id

  def initialize(options = {})
    @name = options[:name]
    @id = options[:id]
  end

end
