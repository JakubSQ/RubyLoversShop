# frozen_string_literal: true

module BooleanValue
  def boolean(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
