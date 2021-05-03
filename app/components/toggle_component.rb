class ToggleComponent < ViewComponent::Base
  def initialize(label:, query_string:)
    @label = label
    @query_string = query_string
  end

  def toggled_off
    request.parameters[@query_string] == "false"
  end

  def toggled_off_url
    query_hash = {}
    query_hash[@query_string] = "false"
    url_for(**request.parameters, **query_hash)
  end

  def toggled_on_url
    url_for(request.parameters.except(@query_string))
  end
end
