class Article < ApplicationRecord
  belongs_to :user
  # 「個人の」記事について、作成経過時間の短い記事を上に表示する。
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }

  # 小学生向け・中学生向け・高校生向けかを判別。引数はboolean型
  def self.inspect_level(level)
    if level
      "○"
    else
      "x"
    end
  end
end
