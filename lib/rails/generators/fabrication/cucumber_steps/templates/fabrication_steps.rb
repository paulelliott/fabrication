module FabricationMethods
  def create_from_table(model_name, table, extra = {})
    fabricator_name = model_name.gsub(/\W+/, '_').downcase.singularize.to_sym
    is_singular = model_name.to_s.singularize == model_name.to_s
    hashes = if is_singular
               [table.rows_hash]
             else
               table.hashes
             end
    @they = hashes.map do |hash|
      hash = hash.merge(extra).inject({}) {|h,(k,v)| h.update(k.gsub(/\W+/,'_').to_sym => v)}
      object = Fabricate.build(fabricator_name, hash)
      yield object if block_given?
      object.save!
      object
    end
    if is_singular
      @it = @they.last
      instance_variable_set("@#{fabricator_name}", @it)
    end
  end
end

World(FabricationMethods)

Given %r{^the following (.+):$} do |model_name, table|
  create_from_table(model_name, table)
end

Given %r{^that (.+) has the following (.+):$} do |parent, child, table|
  child= child.gsub(/\W+/,'_')
  is_child_plural = child.pluralize == child
  parent = parent.gsub(/\W+/,'_').downcase.sub(/^_/, '')
  parent_instance = instance_variable_get("@#{parent}")
  parent_class = parent_instance.class
  if assoc = parent_class.reflect_on_association(child.to_sym) || parent_class.reflect_on_association(child.pluralize.to_sym)
    parent = (assoc.options[:as] || parent).to_s
    child = (assoc.options[:class_name] || assoc.options[:source] || child).to_s
    # source will always be singular, repluralize based on original argument
    child = child.pluralize if is_child_plural
  end
  if child.classify.constantize.method_defined?(parent.pluralize)
    create_from_table(child, table, parent.pluralize => [parent_instance])
  elsif child.classify.constantize.method_defined?(parent)
    create_from_table(child, table, parent => parent_instance)
  else
    create_from_table(child, table)
    if assoc.macro == :has_many
      parent_instance.send("#{assoc.name}=", @they)
    else
      parent_instance.send("#{assoc.name}=", @they.first)
    end
  end
end
