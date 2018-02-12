class CellPhone < AbstractDataObject
  attr_accessor :manufacturer, :model, :year

  def initialize(&closure)
    instance_eval(&closure)
    super
  end
end