# Own ORM Realization
This is an educational project which is created by task of writing own ORM basic realization

# Usage

## New model table creation
Sample code for new model table creation in DSL-style:

```ruby
test_1 = BasicORM.new do |app|
  app.create_table do |table|
    table.add_column :name, table.string, 'not null primary key'
    table.add_column :age, table.integer, 'not null'
    table.add_column :address, table.text
  end
end
```
