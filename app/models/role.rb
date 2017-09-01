# frozen_string_literal: true

class Role < Sequel::Model
  one_to_many :permissions
  many_to_many :api_subjects, class: 'API::APISubject'
  many_to_many :subjects, class: 'Subject'

  def validate
    super
    validates_presence [:name]
  end
end
