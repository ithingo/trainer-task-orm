class BasicORM
  include OwnExceptions
  include DBConnection
  include WorkWithTable
  include TypeOperations::TypeConverter

  def initialize
    @table_name = get_class_name_downcased
    @table_structure = yield(self)
    @table_columns_array = get_table_columns(@table_structure)
    @items = Array.new

    save_table
  end

  def create_table(&closure)
    table_structure = Table.new(&closure)
  end

  def create(item_options = {})
    if new_item_some_params_nil?(item_options, @table_columns_array)
      @items << Item.new(item_options, @table_columns_array)
    end
  end

  def save
    raise ArrayOfItemsIsEmptyError, 'There is no items to save' if @items.length == 0
    @items.each do |item|
      insert_to_table(@table_name, @table_columns_array, item)
    end
  end

  def remove(item)
    #   rescue ItemsAreNotSaved, print "Saving to db -> save()" unless @items.nil?
  end

  def change(item)
  #   rescue ItemsAreNotSaved, print "Saving to db -> save()" unless @items.nil?
  end

  private

  def save_table
    unless @table_structure.user_primary_key
      id_primary_key = ' '
    else
      id_primary_key = 'primary key'.upcase
    end
    @table_structure.user_primary_key
    # connection = connect

    query =  %W?
      CREATE TABLE IF NOT EXISTS #{@table_name} (
        id BIGSERIAL #{id_primary_key},
        #{struct_arr_to_string_arr(@table_structure.columns).join(', ')}
      );
    ?
    # connection.exec query.join(" ")
    # disconnect(connection)
  end

  def insert_to_table(table_name, table_columns, item_object)
    unless item_object.nil?
      connection = connect

      query = %W?
        INSERT INTO #{table_name} (#{table_columns_to_string(table_columns)})
        VALUES (#{item_object.to_s})
      ?

      connection.exec query.join(" ")
      disconnect(connection)
    end
  end

  class Item
    def initialize(new_param_options = {}, table_columns)
      # dynamically generation attr_accessors at first, then asserting new value to existed instance variables

      table_columns.each do |key|
        self.class.send(:define_method, "#{key}=".to_sym) do |value|
          instance_variable_set("@" + key.to_s, value)
        end

        self.class.send(:define_method, key.to_sym) do
          instance_variable_get("@" + key.to_s)
        end

        self.send("#{key}=".to_sym, new_param_options[key])
      end

    end

    def to_s
      attr = self.instance_variables
      values_for_attr = Array.new
      attr.each do |var|
        column_value = self.send(var.to_s.gsub('@', '').to_sym)
        if column_value.class.to_s.downcase.eql? 'string'
          values_for_attr << "'#{column_value}'"
        else
          values_for_attr << column_value
        end
      end
      values_for_attr.join(", ")
    end
  end
end