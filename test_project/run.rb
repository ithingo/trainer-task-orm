require_relative '../test_project/configuration/config_param_getter'

ConfigParamGetter.run

db_name = ConfigParamGetter.db_name
username = ConfigParamGetter.username
pass = ConfigParamGetter.pass

check_connection = TestConnect.connect(db_name, username, pass)
raise PG::Error unless check_connection

App.run do |app|
  app.config_db do |db_configurator|
    db_configurator.db_name = db_name
    db_configurator.username = username
    db_configurator.pass = pass
  end
end

harry_potter = Person.new do
  @first_name = 'Harry'
  @second_name = 'Potter'
  @age = 16
  @debt = 12.234
end

hermione_granger = Person.new do
  @first_name = 'Hermione'
  @second_name = 'Granger'
  @age = 17
  @debt = 0
end

ron_weasley = Person.new do
  @first_name = 'Ron'
  @second_name = 'Weasley'
  @age = 17
  @debt = 1234.5689
end
#
# person_mapper = PersonMapper.new(db_name, username, pass)
# person_mapper.attach(ron_weasley)
# person_mapper.save(hermione_granger)

#
# p App::DBConfigurator.db_name
# p App::DBConfigurator.username
# p App::DBConfigurator.pass

=begin
instance_eval(&closure) for every domain_objects is for assigning values to variables of instance like this:

person_1 = Person.new do
  @name = ....
  @age = ....
  ....
end

=end