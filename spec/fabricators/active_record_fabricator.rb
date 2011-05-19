# ActiveRecord Objects
Fabricator(:division) do
  name "Division Name"
end

Fabricator(:squadron, :from => :division)

Fabricator(:company)
Fabricator(:startup, :from => :company)
