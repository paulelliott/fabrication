class Fabrication::Fabricator

  def initialize(name, &block)
    @fabricator = Fabrication::Proxy.create(name, &block)
  end

  def fabricate(options)
    @fabricator.generate(options)
  end

end
