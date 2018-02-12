module DynamicObjectAndTableOperations
  private

  def connect
    begin
      connection = PG.connect :dbname => @db_name, :user => @username, :password => @pass
    rescue PG::Error => e
      puts e.message
    end
    connection
  end

  def disconnect(connection)
    connection.close if @connection
  end

  def object_props_dump(item)
    # a bit of magic =)
    variables_arr = item.instance_variables   #=> [:@name, :@age.....] - array of Symbols
    dump_var_type = {}
    variables_arr.each do |var|
      # set new element to dump_var_type hash
      # key <- variable name without '@'
      # value_type <- type of key's value in down case letters
      key = var.to_s.gsub('@', '')
      value_type = item.send(key.to_sym).class.to_s.downcase
      dump_var_type[key] = value_type
    end
    dump_var_type
  end

  def define_column_type_on_properties
    dump_with_sql_types = {}
    @dump_var_type.each_key do |key|
      sql_type = @dump_var_type[key]
      dump_with_sql_types[key] = get_real_type(sql_type)
    end
    dump_with_sql_types
  end

  def get_real_type(old_type)
    sql_type = ''
    case old_type
    when 'fixnum', 'integer'
      sql_type = 'INTEGER'
    when 'float'
      sql_type = 'REAL'
    when 'string'
      sql_type = 'TEXT'
    else
      sql_type = 'TEXT'
    end
    sql_type
  end

  def transform_to_column_array_for_table
    #   each hash element -> to string like "name TEXT", "age INTEGER"
    columns_hashed = define_column_type_on_properties
    columns_stringed = []
    columns_hashed.each do |var, sql_type|
      columns_stringed << "#{var} #{sql_type}"
    end
    columns_stringed
  end

  def get_column_names
    columns_array = []
    @dump_var_type.each_key {|key| columns_array << key}
    columns_array
  end

  def get_values_for(item)
    values_array = []
    columns_array = get_column_names
    columns_array.each do |col_name|
      value = item.send(col_name.to_sym)
      if value.class.to_s.downcase == "string"
        values_array << "'#{value}'"
      else
        values_array << value
      end
    end
    values_array
  end

  def transform_attr_to_string(array)
    columns_array = array
    result = "#{columns_array.join(', ')}"
    result
  end

  def create_table(connection)
    table_name = "#{@item_class}_test_table"

    query =  %W?
      CREATE TABLE IF NOT EXISTS #{table_name} (
        #{transform_to_column_array_for_table.join(', ')}
      );
    ?
    connection.exec query.join(" ")

    table_name
  end

  def insert(item, connection)
    query = "INSERT INTO #{@table_name} (#{transform_attr_to_string(get_column_names)})" +
        " VALUES (#{transform_attr_to_string(get_values_for(item))});"
    connection.exec query
  end
end