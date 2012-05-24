require 'piggy_generator'

app = proc do |env| 
	PiggyGenerator.process! env
end

run app
