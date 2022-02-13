class Question < ApplicationRecord
  belongs_to :user
  # 「個人の」質問について、更新経過時間の短い記事を上に表示する。
  default_scope -> { order(updated_at: :desc) }

  # バリデーション
  validates(:title, presence: true, length: { maximum: 100 },
    uniqueness: { case_sensitive: false })
  validates :accuracy_text, presence: true
  validates :difficultylevel_text, presence: true
  validates :questiontext, presence: true
  # 小中高向けの、少なくともどれか1つは選ぶ制約のカスタムバリデーションを読み込む
  include ActiveModel::Validations
  validates_with TargetValidator
  # 質問作成時はfalse(つまりdefault)にする。
  validates :solve, presence: true
  validates :user_id, presence: true

  # その他
  # Action Textのリッチテキストを使用
  has_rich_text :questiontext
end
