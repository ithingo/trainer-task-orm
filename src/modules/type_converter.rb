module TypeConverter
  private

  def stringify_hash_keys(params={})
    result = Hash[params.map { |key, value| [key.to_s, convert_to_sql_type(value)] }]
  end

  def get_class_name_downcased(value)
    value.class.to_s.downcase
  end

  def convert_to_sql_type(old_type)
    # realization for basic autodefinition of variable types
    # but should be changed to old_type.uppercase with correct checking if real type needed
    old_type = get_class_name_downcased(old_type)
    case old_type
    when 'fixnum', 'integer'
      sql_type = 'INTEGER'
    when 'float'
      sql_type = 'REAL'
    when 'string'
      sql_type = 'TEXT'
    when 'trueclass', 'falseclass'
      sql_type = 'BOOLEAN'
    else
      sql_type = 'TEXT'
    end
    sql_type
  end

#   convert operation for writing to and getting from db operations

end