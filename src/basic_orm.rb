class BasicORM
  include WorkWithTable

  def initialize
    @table_name = "#{self.class.to_s.downcase}_table"
    @table = yield(self)
    p @table
  end

  def create_table(&closure)
    table = Table.new(&closure)
    table.freeze
  end
end