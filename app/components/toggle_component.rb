class ToggleComponent < ViewComponent::Base
  def initialize(label:, query_string:)
    @label = label
    @query_string = query_string
  end

  def toggled_on
    request.parameters[@query_string] == "true"
  end

  def toggled_on_url
    query_hash = {}
    query_hash[@query_string] = "true"
    url_for(**request.parameters, **query_hash)
  end

  def toggled_off_url
    url_for(request.parameters.except(@query_string))
  end
end
