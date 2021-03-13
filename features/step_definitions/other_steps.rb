When(/^I try to fabricate "([^"]*)"$/) do |fabricator_name|
  @fabricator_name = fabricator_name
end

Then(/^it should tell me that it isn't defined$/) do
  begin
    step "1 #{@fabricator_name}"
  rescue Exception => e
    e.message.should == "No Fabricator defined for '#{@fabricator_name}'"
  end
end
