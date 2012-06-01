Fabricator(<%= class_name.match(/::/) ? "'#{class_name}'" : ":#{singular_name}" %>) do
<% attributes.each do |attribute| -%>
  <%= attribute.name %> <%= attribute.default.inspect %>
<% end -%>
end
