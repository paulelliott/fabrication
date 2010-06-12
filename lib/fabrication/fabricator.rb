class Fabrication::Fabricator

  def initialize(name, &block)
    @proxy = Fabrication::Proxy.new(name, &block)
  end

  def fabricate(options)
    @proxy.create(options)
  end

end
