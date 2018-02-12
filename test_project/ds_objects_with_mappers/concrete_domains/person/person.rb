class Person < AbstractDataObject
  attr_accessor :first_name, :second_name, :age, :debt

  def initialize(&closure)
    instance_eval(&closure)
    super
  end
end