Fabrication::Transform.define(:company, lambda{|company_name| Company.where(:name => company_name).first })
