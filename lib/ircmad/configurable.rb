module Configurable
  def config
    @config ||= {}
  end

  def set(name, value)
    config[name] = value
  end
end
