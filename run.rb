require_relative 'configuration/app_configurator'

App.run do |app|
  app.config_db do |db_configurator|
    db_configurator.db_name = "temp_db"
    db_configurator.user = "temp_user"
    db_configurator.password = "temp_pass"
  end
end

# p App::DBConfigurator.db_name

=begin
instance_eval(&closure) for every domain_objects is for assigning values to variables of instance like this:

person_1 = Person.new do
  @name = ....
  @age = ....
  ....
end

=end