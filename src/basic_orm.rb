class BasicORM
  include OwnExceptions
  include DBConnection
  include WorkWithTable
  include TypeOperations::TypeForDBConversion
  include CrudOnItems

  def initialize
    @table_name = "#{self.class.to_s.downcase}_table"
    @table = yield(self)
    # p @table.table_columns.first.col_name
  end

  def create_table(&closure)
    table = Table.new(&closure)
  end

  private

  def save_table
  # use sql query and pass here all params
  end
end