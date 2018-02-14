require_relative '../specific/modules/e_converter'
require_relative '../specific/modules/ghost_methods'
require_relative '../specific/modules/file_operations'
require_relative '../specific/modules/db_connection'
require_relative '../specific/modules/crud_on_items'

require_relative '../specific/overriden/object'

class BasicORM
  include TypeConverter

  def initialize
    @table_name = "#{self.class.to_s.downcase}_table"
    table = yield(self)
    # p @table_name
  end

  def create_table(&closure)

  end

end
#
# BasicORM.new({})
#
# class Person < BasicORM
#
# end
#
# Person.new({})
