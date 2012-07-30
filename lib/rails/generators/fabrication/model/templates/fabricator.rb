Fabricator(<%= class_name.match(/::/) ? "'#{class_name}'" : ":#{singular_name}" %>) do
<% width = attributes.map{|a| a.name.size }.max.to_i -%>
<% attributes.each do |attribute| -%>
  <%= "%-#{width}s %s" % [attribute.name, attribute.default.inspect] %>
<% end -%>
end
