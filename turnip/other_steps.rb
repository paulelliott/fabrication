step 'I try to fabricate :fabricator_name' do |fabricator_name|
  @fabricator_name = fabricator_name
end

step "it should tell me that it isn't defined" do
  begin
    # No good way to currently call steps within steps in Turnip...
    Turnip::StepDefinition.execute(self, Turnip::StepModule.all_steps_for(:global), stub(:description => "1 #{@fabricator_name}", :extra_arg => nil))
  rescue Exception => e
    e.message.should == "No Fabricator defined for '#{@fabricator_name}'"
  end
end
