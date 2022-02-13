class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.error_message_conversion(error)
    # Userモデル用エラーメッセージ
    return "名前:空欄にしないで下さい" if (error == "Name can't be blank")
    return "名前:50文字以内にして下さい" if (error == "Name is too long (maximum is 50 characters)")
    return "Email:空欄にしないで下さい" if (error == "Email can't be blank")
    return "Email:無効なEmailです" if (error == "Email is invalid")
    return "Email:255字以内にして下さい" if (error == "Email is too long (maximum is 255 characters)")
    return "パスワード:空欄にしないで下さい" if (error == "Password can't be blank")
    return "パスワード:「パスワード確認」の記入と合致していません" if (error == "Password confirmation doesn't match Password")
    return "パスワード:6文字以上記入して下さい" if (error == "Password is too short (minimum is 6 characters)")
    return "パスワード:72文字以下にして下さい" if (error == "Password is too long (maximum is 72 characters)")

    # Article・Questionモデルの共通エラーメッセージ
    return "タイトル:空欄にしないで下さい" if (error == "Title can't be blank")
    return "タイトル:100字以内にして下さい" if (error == "Title is too long (maximum is 100 characters)")
    return "文章の正しさ:1つ選択して下さい" if (error == "Accuracy text can't be blank")
    return "文章難易度:1つ選択して下さい" if (error == "Difficultylevel text can't be blank")
    return "対象:1つ以上選んで下さい" if (error == "Target can't be blank")
    # Articleモデル専用
    return "記事本体:空欄にしないで下さい" if (error == "Articletext can't be blank")
    # Questionモデル専用
    return "質問本体:空欄にしないで下さい" if (error == "Questiontext can't be blank")
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
