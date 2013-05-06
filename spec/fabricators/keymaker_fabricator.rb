Fabricator(:parent_keymaker_node) do
  transient :placeholder, :transient_with_default => 'my custom value'
  dynamic_field { |attrs| attrs[:placeholder] }
  nil_field nil
  number_field 5
  string_field 'content'
  false_field false
end
