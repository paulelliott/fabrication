placeholder :fabrication_count do
  match /\d+/ do |count|
    count.to_i
  end
  match /a/ do
    1
  end
  match /no/ do
    0
  end
end

steps_for :global do
  def with_ivars(fabricator)
    @they = yield fabricator
    instance_variable_set("@#{fabricator.model}", @they)
  end

  step ':fabrication_count :model_name' do |count, model_name|
    with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
      fab.n(count)
    end
  end

  step 'the following :model_name:' do |model_name, table|
    with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
      fab.from_table(table)
    end
  end

  step 'that :parent has the following :child:' do |parent, child, table|
    with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
      fab.from_table(table)
    end
  end

  step 'that :parent has :fabrication_count :child' do |parent, count, child|
    with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
      fab.n(count)
    end
  end

  step 'that/those :children belong/belongs to that :parent' do |children, parent|
    with_ivars Fabrication::Cucumber::StepFabricator.new(parent) do |fab|
      fab.has_many(children)
    end
  end

  step 'I should see :fabrication_count :model_name in the database' do |count, model_name|
    Fabrication::Cucumber::StepFabricator.new(model_name).klass.count.should == count
  end

  step 'I should see the following :model_name in the database:' do |model_name, table|
    klass = Fabrication::Cucumber::StepFabricator.new(model_name).klass
    klass.where(table.rows_hash).count.should == 1
  end
end
