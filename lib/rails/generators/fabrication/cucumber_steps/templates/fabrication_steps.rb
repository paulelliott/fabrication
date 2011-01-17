module FabricationMethods
  def create_from_table(model_name, table, extra = {})
    fabricator_name = generate_fabricator_name(model_name)
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

  def create_with_default_attributes(model_name, count, extra = {})
    fabricator_name = generate_fabricator_name(model_name)
    is_singular = count == 1
    @they = count.times.map { Fabricate(fabricator_name, extra) }
    if is_singular
      @it = @they.last
      instance_variable_set("@#{fabricator_name}", @it)
    end
  end

  def generate_fabricator_name(model_name)
    model_name.gsub(/\W+/, '_').downcase.singularize.to_sym
  end

  def normalize_table_hash(hash)
    hash.inject({}) do |hash, key_value|
      key, value = key_value
      key = key.gsub(/\W+/, '_')
      hash[key] =
        case value
        when "nil"
          nil
        when /^true|false$/i
          value.downcase == "true"
        when  /^[\d,]+$/
          value.tr(',', '').to_i
        when  /^[\d.,]+$/
          value.tr(',', '').to_f
        else
          value
        end
      hash
    end
  end
end

World(FabricationMethods)

Given /^(\d+) ([^"]*)$/ do |count, model_name|
  create_with_default_attributes(model_name, count.to_i)
end

Given /^the following ([^"]*):$/ do |model_name, table|
  create_from_table(model_name, table)
end

Given /^that ([^"]*) has the following ([^"]*):$/ do |parent, child, table|
  parent = parent.gsub(/\W+/,'_').downcase.sub(/^_/, '')
  parent_instance = instance_variable_get("@#{parent}")
  child = child.gsub(/\W+/,'_').downcase

  child_class = Fabrication::Support.class_for(child.singularize)
  unless child_class.new.respond_to?("#{parent}=")
    parent = parent.pluralize
    parent_instance = [parent_instance]
  end

  create_from_table(child, table, parent => parent_instance)
end
