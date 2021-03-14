namespace :fabrication do
  desc "Display all registered fabricators by class"
  task :list => :environment do
    Fabrication.manager.load_definitions if Fabrication.manager.empty?

    if Fabrication.manager.schematics.none?
      puts "No fabricators found"
      next
    end

    schematic_groups = Fabrication.manager.schematics.group_by do |_name, fabdef|
      fabdef.klass.name
    end

    fabricators = {}
    schematic_groups.sort_by { |klass, _| klass }.each do |klass, groups|
      fabricators[klass] = groups.map(&:first).sort.join(", ")
    end

    class_width = fabricators.keys.max_by(&:size).size + 3 # padding
    names_width = fabricators.values.max_by(&:size).size
    say = lambda do |f1, f2|
      printf "%-#{class_width}s%-#{names_width}s\n", f1, f2
    end

    say["Class", "Fabricator"]
    puts "-" * (names_width + class_width)
    fabricators.each { |klass, names| say[klass, names] }
  end
end
