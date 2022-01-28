# frozen_string_literal: true

module BooleanValue
  def true?(value)
    ActiveModel::Type::Boolean.new.cast(value) == true
  end

  def false?(value)
    !true?(value)
  end
end
