// ---------- インクリメンタルサーチ用の送信データ取得のコード ----------

// オブジェクト形式で送信データを格納
// デフォルトでチェックボックス全てにチェックをつける場合、「文字型」の値を入れること。
// DOMを使い取得する型の値は文字列型で、型を合わせないと要素の削除が行われない。(filterのreturn文で削除する)
// termの値の配列について、「term[0]からterm[1]までの期日」という意味がある
const today = new Date();
let browser_sending_data = { 
             question_or_article: "",
             word: "" ,
             accuracy: ["1", "2", "3", "4", "5"],
             difficulty: ["1", "2", "3", "4", "5"],
             solve: ["false", "true"],
             term: ['2022-01-01',today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate()],
             personalID: ""
            };

const accuracy_array = document.getElementsByName("accuracy_select[]");
const difficulty_array = document.getElementsByName("difficulty_select[]");
const solve_array = document.getElementsByName("solve[]");
const term_array = document.querySelectorAll("#term_from, #term_to");

// 質問モデルに対する検索か記事モデルに対する検索かを判別する
// ルートページ用
if (!!document.getElementsByClassName("black")[0]) {
  if (document.getElementsByClassName("black")[0].value === '質問') {
    browser_sending_data['question_or_article'] = '質問';
  } else {
    browser_sending_data['question_or_article'] = '記事';
  }
}
// ルートページ以外の個人用検索フォーム(/articles/id or /questions/id)
if (browser_sending_data['question_or_article'] === '') {
  // URLのidの部分を抜き出す
  let pathname = location.pathname;
  let id = pathname.match(/\d{1,}/g);
  browser_sending_data['personalID'] = id[0];
  if (pathname[1] === 'q') {
    browser_sending_data['question_or_article'] = '質問';
  } else {
    browser_sending_data['question_or_article'] = '記事';
  }
}
// チェックボックスと関連するaccuracy_array・difficulty_array・solve_arrayに関する設定
// チェックボックスを押す度に、送信データを表すbrowsing_sending_dataのプロパティ(の値)が変わる仕組み
// accuracy_arrayの設定
for (let i = 0; i < accuracy_array.length; i++) {
  accuracy_array[i].addEventListener('click',function(){
    if (accuracy_array[i].checked) {
      browser_sending_data['accuracy'].push(accuracy_array[i].value);
    }else{
      browser_sending_data['accuracy'] = browser_sending_data['accuracy'].filter((eachvalue, index, array) => {
        return eachvalue !== accuracy_array[i].value;
      });
    }
  });
}
// difficulty_arrayの設定
for (let i = 0; i < difficulty_array.length; i++) {
  difficulty_array[i].addEventListener('click', function(){
    if (difficulty_array[i].checked) {
      browser_sending_data['difficulty'].push(difficulty_array[i].value);
    } else {
      browser_sending_data['difficulty'] = browser_sending_data['difficulty'].filter((eachvalue, index, array) => {
        return eachvalue !== difficulty_array[i].value;
      });
    }
  });
}
// solve_arrayの設定
for (let i = 0; i < solve_array.length; i++) {
  solve_array[i].addEventListener('click', function(){
    if (solve_array[i].checked) {
      browser_sending_data['solve'].push(solve_array[i].value);
    } else {
      browser_sending_data['solve'] = browser_sending_data['solve'].filter((eachvalue, index, array) => {
        return eachvalue !== solve_array[i].value;
      });
    }
  });
}
// 日付選択に関係するterm_arrayに関する設定
// 選択した日付が変更されたら送信データを表すdataのプロパティ(termの値)が変わる仕組み
for (let i = 0; i < term_array.length; i++) {
  term_array[i].addEventListener('change', function(){
    browser_sending_data['term'][i] = term_array[i].value;
  });
}
// ---------- インクリメンタルサーチ用の送信データ取得 | 終了 ----------
// ---------- データをサーバーに送信し、検索結果を取得 ----------
let search_word = document.getElementsByClassName("search_input")[0];
let token = document.getElementsByName('csrf-token')[0].content; //HTMLのヘッダからセキュリティトークンの取得
const url = "/incrementalsearch"; // アクセス先のURL

// キーを離す(文字を打つ)度にインクリメンタルサーチ
search_word.addEventListener('input', () => {
  browser_sending_data['word'] = search_word.value;

  const options = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json', // リクエストデータをJSON形式と指定
      'Accept': 'application/json',       // レスポンスデータをJSON形式と指定
      'X-CSRF-Token': token               // CSRFトークンをヘッダに追加
    },
    body: JSON.stringify(browser_sending_data) //JavaScriptのオブジェクトや値(送信データ)を JSON 文字列に変換
  };

  fetch(url, options)
  .then((response) => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
// ---------- データをサーバーに送信し、検索結果を取得 | 終了 ----------
  })  // 検索結果が0件の場合、以下のthenメソッドでエラーが出ますが、その対処はしません。
  .then(server_sending_data => {
// ---------- 取得した検索結果を画面に表示させる ----------
    // 古い検索結果がまだ表示されていたらそれを消す
    if (document.getElementsByClassName("result_display_space").length !== 0) { document.getElementsByClassName("result_display_space")[0].remove(); }
    // 検索結果表示領域自体の設定
    // 表示領域に表示させる記事・質問のリンク数(最大 10個)
    let match_data_max_ten = server_sending_data.length;
    if(match_data_max_ten > 10) { match_data_max_ten = 10; }
    let search_result_display = document.createElement("div");
    search_result_display.setAttribute("class", "result_display_space");
    // 検索結果表示領域内の検索件数表示の設定
    const search_result_count = document.createElement("div");
    search_result_count.setAttribute("class", "count_display_space");
    search_result_count.insertAdjacentText('afterbegin',`${server_sending_data.length}件`);
    search_result_display.insertAdjacentHTML('afterbegin',search_result_count.outerHTML);
    // 検索結果表示領域内の各件の表示の設定(リンク数は最大10個)
    for (let i = 0; i < match_data_max_ten; i++) {
      let each_result_display = document.createElement("div");
      each_result_display.setAttribute("class", "each_result");
      let link_area = document.createElement("a");
      link_area.setAttribute("class", "link");
      if (browser_sending_data['question_or_article'] === '質問') {
        link_area.setAttribute("href", `/questions/${server_sending_data[i]['id']}/browsing`);
      } else {
        link_area.setAttribute("href", `/articles/${server_sending_data[i]['id']}/browsing`);
      }
      link_area.insertAdjacentText('afterbegin', server_sending_data[i]['title']);
      each_result_display.insertAdjacentHTML('afterbegin', link_area.outerHTML);
      search_result_display.insertAdjacentHTML('beforeend', each_result_display.outerHTML);
    }
    // 検索結果を表示させる
    let search_word_input_area = document.getElementsByClassName("search")[0];
    search_word_input_area.insertAdjacentHTML('afterend',search_result_display.outerHTML);
  })
});
// ---------- 取得した検索結果を画面に表示させる | 終了 ----------
// ---------- 検索結果表示領域以外の領域を押したら、検索結果表示領域を消す。----------
document.addEventListener('click',(e) => {
  if((document.getElementsByClassName("result_display_space").length !== 0)&&(!e.target.closest('.result_display_space'))) {
    document.getElementsByClassName("result_display_space")[0].remove();
  }
});
// ---------- 検索結果表示領域以外の領域を押したら、検索結果表示領域を消す。| 終了 ----------