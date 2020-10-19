require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

require_relative 'lib/cookbook'
require_relative 'lib/recipe'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do # router
  @cb = Cookbook.new(__dir__ + "/lib/recipes.csv")
  @recipes = @cb.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  @cb = Cookbook.new(__dir__ + "/lib/recipes.csv")
  @name = params['title']
  @desc = params['desc']
  @rating = params['rating']
  @prep_t = params['prep_t']
  @path = params['path']
  @recipe = Recipe.new(@name, @desc, @rating, @prep_t, false, @path)
  @cb.add_recipe(@recipe)
  "Success <a href='/'>Back to home</a>"
end

get '/remove' do
  @index = params['idx'].to_i
  @cb = Cookbook.new(__dir__ + "/lib/recipes.csv")
  @cb.remove_recipe(@index)
  "Index deleted: #{@index}. <a href='/'>Back to home</a>"
end
