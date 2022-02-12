class TargetValidator < ActiveModel::Validator
  def validate(record)
    unless record.Eschool_level || record.JHschool_level || record.Hschool_level
      record.errors[:target] << "can't be blank"
    end
  end
end
