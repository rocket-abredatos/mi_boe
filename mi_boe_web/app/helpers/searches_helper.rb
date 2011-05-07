module SearchesHelper
  def parse_facet_fields(category, category_i18n)
    result = '<h3>' + t(category_i18n) + '</h3>'
    attribute = @search.facet_counts.facet_fields.send(category)
    for i in 0..(attribute.count / 2 - 1)
      result += ' - <a>' + attribute[i*2].to_s + ' (' + attribute[i*2 + 1].to_s + ')</a><br/>'
    end
    result + '<br/><br/>'
  end
end
