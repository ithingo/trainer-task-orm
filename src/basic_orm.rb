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

  def save(item)

  end

  def remove(item)

  end

  def change(item)

  end

  private

  def save_table

    if @table_structure.user_primary_key
      id_primary_key = ' '
    else
      id_primary_key = 'primary key'.upcase
    end
    # id_primary_key = @table_structure.user_primary_key? ? '' : ' primary key'.upcase
    connection = connect

    query =  %W?
      CREATE TABLE IF NOT EXISTS #{@table_name} (
        id BIGSERIAL #{id_primary_key},
        #{struct_arr_to_string_arr(@table_structure.columns).join(', ')}
      );
    ?
    query.join(" ")

    connection.exec query.join(" ")
    disconnect(connection)
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
  end
end