class Person < AbstractDataObject
  attr_accessor :first_name, :second_name, :age

  def initialize(&closure)
    instance_eval(&closure)
  end
end