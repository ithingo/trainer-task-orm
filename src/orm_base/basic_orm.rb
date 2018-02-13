require_relative '../specific/modules/type_converter'
require_relative '../specific/modules/ghost_methods'
require_relative '../specific/modules/file_operations'
require_relative '../specific/modules/db_connection'
require_relative '../specific/modules/crud_on_items'

require_relative '../specific/overriden/object'

class BasicORM
  include TypeConverter

  def initialize(params = {})
    @table_name = "#{self.class.to_s.downcase}_table"
    # p @table_name
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
