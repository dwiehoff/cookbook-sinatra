class ScrapeAllrecipesService
  def initialize

  end

  def by_ingredient(ingredient)
    # return a list of `Recipes` built from scraping the web
    url = "https://www.allrecipes.com/search/results/?IngIncl=#{ingredient}"
    parser = Nokogiri::HTML(open(url).read, nil, Encoding::UTF_8.to_s)
    names = parser.search('.fixed-recipe-card__title-link').css('span.fixed-recipe-card__title-link').map { |name| name.text.strip }
    descs = parser.search('.fixed-recipe-card__description').map { |desc| desc.text.strip }
    ratings = parser.search('.fixed-recipe-card__ratings').map { |rating| rating.css('span.stars').attribute('data-ratingstars').value } # [0].to_f.round(1) }
    paths = parser.search('a.fixed-recipe-card__title-link').map { |link| link.attribute('href').value.to_s.match(/https:\/\/www.allrecipes.com(?<path>\/.+\/)/).named_captures['path'] }
    names.map.with_index { |n, i| Recipe.new(n, (descs[i] || "description unavailable"), (ratings[i].to_s.to_f.round(1) || 0), paths[i]) }
  end

  def by_individual(path)
    url = "https://www.allrecipes.com#{path}"
    parser = Nokogiri::HTML(open(url).read, nil, Encoding::UTF_8.to_s)
    # > document.querySelector('.recipe-info-section').querySelectorAll('.two-subcol-content-wrapper')[0].querySelectorAll('.recipe-meta-item')[0].querySelector('.recipe-meta-item-body')   >>> text
    prep_t = parser.search('.recipe-info-section')
                   .css('.two-subcol-content-wrapper')[0]
                   .css('.recipe-meta-item')[0]
                   .css('.recipe-meta-item-body').text.strip.match(/\d+/)[0].to_i
    return prep_t
  end
end
