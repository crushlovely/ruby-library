require 'rexml/parsers/pullparser'

module CustomTruncation

  def truncate_html(len = 30)
    p = REXML::Parsers::PullParser.new(self)
    tags = []
    new_len = len
    results = ''
    while p.has_next? && new_len > 0
      p_e = p.pull
      if p_e.event_type == :start_element && ['br', 'meta', 'input', 'img', 'hr'].include?(p_e[0])
        results << "<#{p_e[0]}#{attrs_to_s(p_e[1])} />"
      elsif p_e.event_type == :end_element && ['br', 'meta', 'input', 'img', 'hr'].include?(p_e[0])
        # Do Nothing
      else
        case p_e.event_type
        when :start_element
          tags.push p_e[0]
          results << "<#{tags.last}#{attrs_to_s(p_e[1])}>"
        when :end_element
          results << "</#{tags.pop}>"
        when :text
          results << p_e[0].first(new_len)
          new_len -= p_e[0].length
        else
          results << "<!-- #{p_e.inspect} -->"
        end
      end
    end
    
    tags.reverse.each do |tag|
      results << "..." if tag == tags.reverse.last
      results << "</#{tag}>"
    end
    results
  end

  private

  def attrs_to_s(attrs)
    if attrs.empty?
      ''
    else
      res = ' '
      res += attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')
      return res
    end
  end
end

