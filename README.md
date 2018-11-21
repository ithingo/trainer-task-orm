# Own ORM Realization
This was an educational project which was created by task of writing own ORM basic realization when I was a trainee) I tried to make just a simple implementation of ORM without plans for further development of it.

# Usage

## New model table creation
Sample code for new model table creation in DSL-style:

```ruby
test_1 = BasicORM.new do |app|
  app.create_table do |table|
    table.add_column :name,     table.string,   'not null primary key'
    table.add_column :age,      table.integer,  'not null'
    table.add_column :address,  table.text
  end
end
```

## New item creation
Sample that shows how to create new item with this model. You should use only those params aka column names which are defined before. All 'extra' object properties will be ignored without migrations which are not yet supported. =)

```ruby
test_1.create(name: "Richard Stallman", age: 65, address: "USA")
test_1.create(name: "Steve Wozniak", age: 68, address: "USA")
test_1.create(name: "Donald J. Trump", age: 71, address: "Washington D.C.")
```

## Save all objects
Sample of code to save all our items to atabase. For example, we create two items with properties for our table specified above

```ruby
test_1.create(name: "Steve Wozniak", age: 68, address: "USA")
test_1.create(name: "Donald J. Trump", age: 71, address: "Washington D.C.")
# ...
test_1.save
```

### WRONG USAGE: 
```ruby
test_1.create(name: "Sean Connery", age: 87, address: "Edinburg", party: "Scottish National Party") #=> 'party' will be ignored
test_1.create(name: '', age: 21, address: "Taganrog")       #=> Do not have all params
test_1.create(name: 'Jason Black', age: 21, address: "")    #=> Do not have all params

```

## Update and delete
Sampple usage of deletion and changing.

```ruby
# if method save() ain't been called, ORM raises exception
test_1.delete(where: 'name like Donald%')       #=>  You try to delete something, but items are not saved
# With raising exception (just 1 time) ORM automatically saves all data to table
# If an expresiion is used again, there will be no error and all will work correctly

test_1.delete(where: 'name like Donald%')
test_1.delete(where: 'age > 34')

test_1.update(where: 'age = 64', change: 'age = 65')

```

### WRONG USAGE: 
```ruby
test_1.delete(where:'age is 34')                #=> Wrong relation for data
test_1.delete(where: 'name is Donald%')         #=> Wrong relation for data
test_1.delete(where: '')                        #=> There is no condition for action delete
test_1.delete()                                 #=> No condition at all!
test_1.delete('')                               #=> No condition at all!

test_1.update(where: '', change: 'age = 65')    #=> There is no condition for action update
test_1.update(where: 'age = 64', change: '')    #=> Do not know what you want to update
test_1.update()                                 #=> No condition at all!
test_1.update('')                               #=> No condition at all!

```

## Get all info (select all rows)

```ruby
result = test_1.see_all
```

## Delete all info (with dropping table)

```ruby
test_1.clear_all!
```

## What should expect at output:

```ruby
"CREATE TABLE IF NOT EXISTS basicorm_table ( id BIGSERIAL  , name VARCHAR(255) NOT NULL PRIMARY KEY, age INTEGER NOT NULL, address TEXT  );"
"INSERT INTO basicorm_table (name, age, address) VALUES ('Richard Stallman', 65, 'USA');"
"INSERT INTO basicorm_table (name, age, address) VALUES ('Donald J. Trump', 71, 'Washington D.C.');"
"DELETE FROM basicorm_table WHERE id IN ( SELECT id FROM basicorm_table WHERE name like 'Donald%' );"
"DELETE FROM basicorm_table WHERE id IN ( SELECT id FROM basicorm_table WHERE age > 34 );"
"UPDATE basicorm_table SET age = 65 WHERE id IN ( SELECT id FROM basicorm_table WHERE age = 64 );"
"SELECT * FROM basicorm_table;"
"DROP TABLE IF EXISTS basicorm_table;"
```
