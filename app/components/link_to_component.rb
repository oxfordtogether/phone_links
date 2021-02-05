class LinkToComponent < ViewComponent::Base
  def initialize(text, path)
    @text = text
    @path = path
  end
end
