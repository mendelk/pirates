require './pirate_app'
use Rack::MethodOverride
run MendelsPirates::App.new