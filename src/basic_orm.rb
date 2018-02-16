class BasicORM
  include OwnExceptions::Common
  include DBConnection
  include TypeOperations::AbstractDomainObject
  include WorkWithTable
  include TypeOperations::TypeConverter
  include TypeOperations::SqlQueriesImitation

  def initialize
    @table_name = get_class_name_downcased
    @table_structure = yield(self)
    @table_columns_array = get_table_columns(@table_structure)
    @logger = Logger.new
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
    @items = Array.new
  end

  def delete(condition)
    modify_data('delete', condition)
  end

  def change(condition)
    modify_data('update', condition)
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
      # connection = connect
      query = %W?
        INSERT INTO #{table_name} (#{table_columns_to_string(table_columns)})
        VALUES (#{item_object.to_s})
      ?
      # connection.exec query.join(" ")
      # disconnect(connection)
    end
  end

  def modify_data(action, pseudo_query)
    unless @items.length == 0
      puts 'Saving items...'
      save
      raise ItemsAreNotSaved, "You try to #{action} something, but items are not saved"
    end
    raise NoQueryForAction, "There is no condition for action #{action}" if pseudo_query.nil?

    case action
    when 'delete'
      p pseudo_query_to_real @table_columns_array, pseudo_query
    when 'update'

    end
  end

end