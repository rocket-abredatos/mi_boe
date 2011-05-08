module SearchesHelper
  def parse_facet_fields(category, category_i18n)
    result = '<h3>' + t(category_i18n) + '</h3>'
    attribute = @search.facet_counts.facet_fields.send(category)
    for i in 0..(attribute.count / 2 - 1)
      result += ' - <a>' + attribute[i*2].to_s + ' (' + attribute[i*2 + 1].to_s + ')</a><br/>'
    end
    result + '<br/><br/>'
  end

  def pagination
    result = ''
    if @search.response.numFound > 0
      if @search.response.numFound < 20
        for i in 0..(@search.response.numFound / 10)
          result += (page_link i) + ' | '
        end
      elsif (@search.response.start / 10) < 5
        for i in 0..9
          result += (page_link i) + ' | '
        end
        result += ' ... ' + (page_link @search.response.numFound / 10)
      elsif (@search.response.start / 10) > (@search.response.numFound / 10 - 4) 
        result += (page_link 0) + ' ... '
        for i in (@search.response.numFound / 10 - 9)..(@search.response.numFound / 10)
          result += (page_link i) + ' | '
        end
      else
        result += (page_link 0) + ' ... '
        for i in (@search.response.start / 10 - 4)..(@search.response.start / 10 + 4)
          result += (page_link i) + ' | '
        end
        result += ' ... ' + (page_link @search.response.numFound / 10)
      end
    end
    result
  end
  
  private
    def page_link(i)
       if (i * 10) == @search.response.start
        (i + 1).to_s
      else
       link_to((i + 1).to_s, {:action => "create", :search => {:query => @search.responseHeader.params.q, :start => (i * 10).to_s}}, {:method => 'post'})
      end
    end
end
