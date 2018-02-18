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
    @items = Array.new
    save_table
  end

  def create_table(&closure)
    table_structure = Table.new(&closure)
  end

  def create(item_options = {})
    raise NoColumnParamsError , 'Do not have all params' unless new_item_some_params_not_nil?(item_options, @table_columns_array)
    @items << Item.new(item_options, @table_columns_array)
  end

  def save
    raise ArrayOfItemsIsEmptyError, 'There is no items to save' if @items.length == 0
    @items.each do |item|
      insert_to_table(@table_name, @table_columns_array, item)
    end
    @items = Array.new
  end

  def delete(condition_options = {})
    modify_data('delete', condition_options)
  end

  def update(condition_options = {})
    modify_data('update', condition_options)
  end

  def see_all
    result = get_all_data
    result
  end

  def clear_all!
    drop_table
  end

  private

  def save_table
    unless @table_structure.user_primary_key
      id_primary_key = ' '
    else
      id_primary_key = 'primary key'.upcase
    end
    query =  %W?
      CREATE TABLE IF NOT EXISTS #{@table_name} (
        id BIGSERIAL #{id_primary_key},
        #{struct_arr_to_string_arr(@table_structure.columns).join(', ')}
      );
    ?
    execute_query query.join(" ")
  end

  def insert_to_table(table_name, table_columns, item_object)
    unless item_object.nil?
      query = %W?
        INSERT INTO #{table_name} (#{table_columns_to_string(table_columns)})
        VALUES (#{item_object.to_s});
      ?
      execute_query query.join(" ")
    end
  end

  def modify_data(action, condition)
    unless @items.length == 0
      puts 'Saving items...'
      save
      raise ItemsAreNotSaved, "You try to #{action} something, but items are not saved"
    end

    raise NoQueryForAction, 'No condition at all!' if condition.length == 0

    pseudo_query = condition[:where]
    raise NoQueryForAction, "There is no condition for action #{action}" if pseudo_query == ''
    if action == 'update'
      what_to_set = condition[:change]
      raise NoQueryForAction, 'Do not know what you want to update' if what_to_set == ''
    end

    changed_pseudo_query = pseudo_query_to_real @table_columns_array, pseudo_query, @table_structure.columns

    case action
    when 'delete'
      query = %W?
        DELETE FROM #{@table_name} WHERE id IN (
          SELECT id FROM #{@table_name} WHERE #{changed_pseudo_query}
        );
      ?
    when 'update'
      query = %W?
        UPDATE #{@table_name} SET #{what_to_set}
        WHERE id IN (
          SELECT id FROM #{@table_name} WHERE #{changed_pseudo_query}
        );
      ?
    end
    execute_query query.join(" ")
  end

  def drop_table
    query = %W?
      DROP TABLE IF EXISTS #{@table_name};
    ?
    execute_query query.join(" ")
  end

  def get_all_data
    connection = connect
    query = %W?
      SELECT * FROM #{@table_name};
    ?
    result = execute_query query.join(" ")
    disconnect(connection)
    result
  end
end