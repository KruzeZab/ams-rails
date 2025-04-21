module ErrorFormat
  def formatted_errors(errors)
    errors.messages.transform_keys { |key| key.to_s.camelize(:lower) }
  end
end