# Cookbook application that manages recipes
# list of your recipes: list, add, delete
# MVC pattern
#   - Model: basic object to manipulate => data repo
#   - View:  to display information (puts), ask for information (gets) => interaction
#   - Controller: middleman ... fetch and store data (Model) <> show or gather data (View)
# 1. Identify your components and their responsibilities
#      Components: CookbookRepoDB(CSV)/Recipe (Model), Pages (View), Processing (Controller)
#


# SECOND [REPO, structure to store recipes (=cookbook), interacts with database]

require 'csv'
require_relative 'recipe'

class Cookbook
  # Repository
  def initialize(csv_file_path)
    # load existing recipe from CSV
    @csv_file_path = csv_file_path # __dir__ + "/" + csv_file_path
    @recipes       = load_recipes(@csv_file_path) # nested array
  end

  def load_recipes(csv_file_path)
    # structure of CSV: name,description
    csv_data = []
    csv_options = { col_sep: ',', quote_char: '"' }
    CSV.foreach(csv_file_path, csv_options) do |record|
      # each line as array
      csv_data << record
    end
    csv_data.map { |recipe| Recipe.new(recipe[0], recipe[1], recipe[2].to_f, recipe[3], recipe[4] == 'true', recipe[5]) }
    # [["Rec1", "Steps"],["Rec2", "Steps"]] .. should be [rec_inst1, rec_inst2]
    # require_relative 'recipe' ok?
  end

  def store_recipes
    CSV.open(@csv_file_path, 'wb') do |csv_row|
      @recipes.each { |recipe| csv_row << [recipe.name.to_s, recipe.description.to_s, recipe.rating.to_s, recipe.prep_t.to_s, recipe.done?, recipe.path.to_s] }
    end
  end

  def all
    # returns all recipes
    @recipes
  end

  def add_recipe(recipe)
    # adds new recipe to cookbook
    @recipes << recipe
    store_recipes
  end

  def remove_recipe(recipe_index)
    # removes recipe from cookbook
    @recipes.delete_at(recipe_index)
    store_recipes
  end

  def mark_recipe_done(index)
    @recipes[index].done = true
    store_recipes
  end
end
