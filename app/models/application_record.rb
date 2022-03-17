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

  # モデル作成時にカラムに追加されるcreated_atとupdated_atの表記を変換
  def self.date_expression_change(before_expression)
    # 右から順に年・月・日の情報を取得。配列に格納される
    date = before_expression.to_s.scan(/\d{4}-\d{1,2}-\d{1,2}/)
    splited = date[0].split("-")
    # 月・日の一文字目の0を消す。(ex: "03"→"3")
    y_m_d = splited.map do |figure|
      if figure[0] == "0"
        figure = figure[1]
      end
      figure
    end
    y_m_d[0] + "年" + y_m_d[1] + "月" + y_m_d[2] + "日"
  end

  # 記事・質問検索用スコープ
  # 検索結果数が0件になる場合、where(id: nil)で、強制的にActiveRecord::Relationの中身を空にしている
  def self.title(content)
    if content.blank?
      where(id: nil)
    else
      where("title LIKE ?", '%' + content + '%')
    end
  end

  def self.difficulty(dif_select)
    where(difficultylevel_text: dif_select)
  end

  def self.accuracy(ac_select)
    where(accuracy_text: ac_select)
  end

  def self.term(term_from, term_to)
    if term_from == "" || term_to == ""
      where(id: nil)
    else
      where("updated_at >= :start_date AND updated_at <= :end_date",
      { start_date: term_from, end_date: term_to })
    end
  end

  def self.who(user_id)
    where(user_id: user_id)
  end

  def self.solve?(solve)
    where(solve: solve)
  end

  # root_pathアクセス時に表示される検索フォーム(ログイン前提)に関するメソッド
  # 変数modelの取り得る値は、"Article"と"Question"のみ
  def self.root_search_form(model = "Article")
    if (model != "Article")
      Question.new
    else
      Article.new
    end
  end
end
