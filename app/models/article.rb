class Article < ApplicationRecord
  belongs_to :user
  # 「個人の」記事について、更新経過時間の短い記事を上に表示する。
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :articletext, presence: true
  validates :accuracy_text, presence: true
  validates :difficultylevel_text, presence: true
  validates(:title, presence: true, length: { maximum: 100 },
            uniqueness: { case_sensitive: false })

  # 小中高向けの、少なくともどれか1つは選ぶ制約のカスタムバリデーションを読み込む
  include ActiveModel::Validations
  validates_with TargetValidator

  # Action Textのリッチテキストを使用
  has_rich_text :articletext

  # 小学生向け・中学生向け・高校生向けかを判別。引数はboolean型
  def self.inspect_level(level)
    if level
      "○"
    else
      "x"
    end
  end
end
