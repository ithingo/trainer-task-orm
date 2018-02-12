class AbstractDataObjectMapper
  def initialize(db_name, username, pass)
    @db_name = db_name
    @username = username
    @pass = pass
    @items_array = Array.new
  end

  def attach(item)
    @items_array << item
    @item_class = item.class.to_s.downcase
    @item_sample ||= @table_name.clone
  end

  def save
    connection = connect
    @table_name = create_table(connection)
    disconnect(connection)
  end

  def update(item)
    # connection = connect
    #
    # disconnect(connection)
    #search in array, update with closure
    #and then call method that updates the db
  end

  def delete(item)
    # connection = connect
    #
    # disconnect(connection)
  end

  def fin_by_id(id)
    # connection = connect
    #
    # disconnect(connection)
  end

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
    dump_var_type = object_props_dump(@item_sample)
    dump_with_sql_types = {}
    dump_var_type.each_key do |key|
      sql_type = dump_var_type[key]
      dump_with_sql_types[key] = sql_type
    end
    dump_with_sql_types
  end

  def get_real_type(old_type)
    sql_type = ''
    case old_type
    when 'fixnum'
      sql_type = 'INTEGER'
    when 'float'
      sql_type = 'NUMERIC'
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
      stringed_column = "#{var} #{sql_type}"
    end
    columns_stringed
  end

  def create_table(connection)
    table_name = "#{@item_class}_test_table"

    # check if table exists

    # insert into query an array joined by ','
    connection.exec(%Q?
      CREATE TABLE IF NOT EXISTS #{table_name} (
        #{transform_to_column_array_for_table.join(', ')}
      );
    ?)

    table_name
  end

  def insert(item)
  end
end