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

## New item creation
Sample that shows how to create new item with this model. You should use only those params aka column names which are defined before. All 'extra' object properties will be ignored without migrations which are not yes supported =)

```ruby
test_1.create(name: "Sean Connery", age: 87, address: "Edinburg")

# wrong: test_1.create(name: "Sean Connery", age: 87, address: "Edinburg", party: "Scottish National Party")
# party will be ignored
```

## Save all objects
Sample of code to save all our items to atabase. For example, we create two items with properties for our table specified above

```ruby
test_1.create(name: "Vladimir Putin", age: 65, address: "Moscow")
test_1.create(name: "Donald J. Trump", age: 71, address: "Washington D.C.")
# ...
test_1.save
```
