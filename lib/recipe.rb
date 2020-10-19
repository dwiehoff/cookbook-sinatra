# FIRST [MODEL]
class Recipe
  attr_reader :name, :description, :rating, :prep_t, :path

  def initialize(name, desc, rating = 0, prep_t = 0, done = false, path)
    @name        = name
    @description = desc
    @rating      = rating
    @done        = done
    @prep_t      = prep_t
    @path        = path
  end

  def done?
    @done
  end

  def done=(bool)
    @done = bool
  end

  def prep_t=(mins)
    @prep_t = mins
  end
end
