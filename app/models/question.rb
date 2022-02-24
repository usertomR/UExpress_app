class Question < ApplicationRecord
  # 「個人の」質問について、更新経過時間の短い記事を上に表示する。
  default_scope -> { order(updated_at: :desc) }

  # association
  belongs_to :user

  # 「気になるボタン」関連の実装
  has_many :curious_questions, classname: "CuriousQuestion",
                                dependent: :destroy,
                                inverse_of: :question
  has_many :sum_curious_per_question, through: :curious_questions, source: :user

  # バリデーション
  validates(:title, presence: true, length: { maximum: 100 },
    uniqueness: { case_sensitive: false })
  validates :accuracy_text, presence: true
  validates :difficultylevel_text, presence: true
  validates :questiontext, presence: true
  # 小中高向けの、少なくともどれか1つは選ぶ制約のカスタムバリデーションを読み込む
  include ActiveModel::Validations
  validates_with TargetValidator
  # 質問作成時はfalse(つまりdefault)にする.trueとfalseの2択
  # URL: https://railsguides.jp/active_record_validations.html?version=6.0#presence
  validates :solve, inclusion: { in: [true, false] }
  validates :user_id, presence: true

  # その他
  # Action Textのリッチテキストを使用
  has_rich_text :questiontext
end
