class TargetValidator < ActiveModel::Validator
  def validate(record)
    unless record.Eschool_level || record.JHschool_level || record.Hschool_level
      record.errors[:target] << '小学生・中学生・高校生向けのどれか1つは選択して下さい'
    end
  end
end
