class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.error_message_conversion(error)
    # Articleモデルのエラーメッセージ
    return "記事タイトル:空欄にしないで下さい" if (error == "Title can't be blank")
    return "文章の正しさ:1つ選択して下さい" if (error == "Accuracy text can't be blank")
    return "文章難易度:1つ選択して下さい" if (error == "Difficultylevel text can't be blank")
    return "対象:1つ以上選んで下さい" if (error == "Target can't be blank")
    return "記事本体:空欄にしないで下さい" if (error == "Articletext can't be blank")
  end

  # 小学生向け・中学生向け・高校生向けかを判別。引数はboolean型
  def self.inspect_level(level)
    if level
      "○"
    else
      "x"
    end
  end
end
