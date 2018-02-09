Object.class_eval do
	class << self
		def define_attr_accessors(*options)
			options.each do |attr|
				
				#it's a huuuuuuge string containing two methods
				class_eval %Q?
					def #{attr}
						@#{attr}
					end

					def #{attr}= ( new_val )
						@#{attr} = new_val
					end
				?
			end
		end
	end
end

class Item
	define_attr_accessors :name, :age
end

item = Item.new
item.name = "Jack"
item.age = 23
p item

#-----------
# # example of usage, not working now
# item = Item.new do |item|
#   item.name = "Jack"
#   item.age = 84
#   #smth else
#   end
# p item.name
