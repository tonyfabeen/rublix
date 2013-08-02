class ContainerService

  attr_accessor :errors, :container

  def initialize(params)
    @errors = []
    @container = params
    validate
  end

  def create
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.create
  end

  def start
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.start
  end

  def stop
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.stop
  end

  def destroy
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.destroy
  end

  def reboot
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.reboot
  end

  def shutdown
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.shutdown
  end

  def response_errors
    error_hash = {:errors => @errors}
    error_hash.to_json
  end

  private

  def validate
    @errors << "Name must be filled" if @container['name'].nil?
  end

end

