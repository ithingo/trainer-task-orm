class CellPhone
  attr_accessor :manufacturer, :model, :year

  def initialize(&closure)
    instance_eval(&closure)
  end
end