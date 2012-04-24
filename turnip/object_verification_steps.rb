steps_for :global do
  ORDINALS = {
    "first" => 0,
    "second" => 1
  }

  def dehumanize(string)
    string.gsub(/\W+/,'_').downcase
  end

  def generate_fabricator_name(model_name)
    model_name.singularize.to_sym
  end

  def get_class(model_name)
    fabricator_name = generate_fabricator_name(model_name)
    Fabrication.schematics[fabricator_name].klass
  end


  step 'that :object_name should be persisted' do |object_name|
    object_name = dehumanize(object_name)
    object = Fabrication::Cucumber::Fabrications[object_name]
    object.should be_persisted
  end

  step 'that :object_name should have :value for a :field' do |object_name, value, field|
    object_name = dehumanize(object_name)
    object = Fabrication::Cucumber::Fabrications[object_name]
    object.send(field).should == value
  end

  step 'they should be persisted' do
    @they.each do |object|
      object.should be_persisted
    end
  end

  step 'they should reference that :parent_name' do |parent_name|
    parent_name = dehumanize(parent_name)
    parent = Fabrication::Cucumber::Fabrications[parent_name]
    parent_class = get_class(parent_name)
    parent_class_name = parent_class.to_s.underscore

    @they.each do |object|
      object.send(parent_class_name).should == parent
    end
  end

  step 'the :ordinal should have :value for a :field' do |ordindal, value, field|
    object = @they[ORDINALS[ordindal]]
    object.send(field).should == value
  end

  step 'that :child_name should reference that :parent_name' do |child_name, parent_name|
    parent_name = dehumanize(parent_name)
    parent = Fabrication::Cucumber::Fabrications[parent_name]
    parent_class = get_class(parent_name)
    parent_class_name = parent_class.to_s.underscore
    child_name = dehumanize(child_name)
    child = Fabrication::Cucumber::Fabrications[child_name]
    child.send(parent_class_name).should == parent
  end
end
