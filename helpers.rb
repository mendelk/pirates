module Helpers
  def generate_slug(string)
    string.to_s.downcase.scan(/\w+/).join('-')
  end
  def model_slug(model)
    Object.const_get(model)::SLUG
  end
end