import
  os,
  pure,
  data,
  json,
  sugar,
  tables,
  options,
  unittest,
  strformat

const KONEKODIR = "~/.local/share/koneko/cache".expandTilde

let mode1 = "mode1.json".parseFile
let mode2 = "mode2.json".parseFile
let mode3 = "mode3.json".parseFile
#let mode4 = "mode4.json".parseFile
#let mode5 = "mode5.json".parseFile

let mode1_illusts = mode1["illusts"]

suite "pure":
  test "split_backslash_last":
    block:
      check split_backslash_last("one/two/three") == "three"

  test "generate_filepath":
    block:
      check generate_filepath("myfile") == "~/Downloads/myfile".expandTilde

  test "prefix_filename":
    block:
      check prefix_filename("one/two/three.png", "four", 1) == "001_four.png"

  test "prefix_artist_name":
    block:
      check prefix_artist_name("name", 1) == "01\n                   name"

  test "find_number_map":
    block:
      let fnm = collect(newSeq):
        for y in 1..6:
          for x in 1..5:
            find_number_map(x, y).get()

      let myrange = collect(newSeq):
        for i in 0..29:
          i

      check fnm == myrange

  test "print_multiple_imgs":
    block:
      print_multiple_imgs(mode1_illusts)  # #22 has 8 pages

  test "url_given_size":
    block:
      check url_given_size(mode1["illusts"][0], "medium") == "https://i.pximg.net/c/540x540_70/img-master/img/2020/05/14/06/45/24/81547984_p0_master1200.jpg"

  test "post_title":
    block:
      check post_title(mode1_illusts, 0) == "みこっちゃん"

  test "medium_urls":
    block:
      check medium_urls(mode1_illusts) == @["https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/14/06/45/24/81547984_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/12/06/36/27/81501385_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/10/23/10/38/81468125_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/09/04/31/04/81416496_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/07/05/48/03/81368866_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/04/05/17/46/81276257_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/04/20/04/52/26/80923496_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/04/11/01/49/35/80701898_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/03/10/04/07/08/80017594_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/02/29/19/09/35/79799236_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/02/22/21/21/50/79658392_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/02/17/05/31/08/79549991_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/01/10/21/50/56/78823485_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/01/01/02/50/56/78628383_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/12/21/20/13/12/78403815_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/12/20/03/00/33/78378594_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/12/08/19/09/16/78201587_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/11/14/00/47/58/77804404_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/31/06/25/38/77565309_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/24/22/50/31/77460464_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/18/06/06/27/77347697_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/02/07/26/09/77068750_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/09/09/04/32/38/76695217_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/09/01/01/39/35/76561671_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/08/08/04/11/57/76138362_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/27/16/34/45/75933779_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/20/02/29/47/75810852_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/13/17/12/09/75698678_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/06/17/40/44/75579060_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/06/29/09/44/52/75457783_p0_square1200.jpg"]

  test "post_titles_in_page":
    block:
      check post_titles_in_page(mode1_illusts) == @["みこっちゃん", "おりじなる", "0510", "5.3", "おりじなる", "ミコ誕オメ画！", "5.2", "5.1", "310", "Midnight Sun", "222", "バレンタイン", "祝！！！", "あけましておめでとうございます", "ミコサンタ", "C97告知", "ミコバニー", "たちかわ楽市2019仕様4人組", "ハロミコ", "夏服", "御坂美琴写真集１０用", "常盤台中学指定体操服改", "ツイッターまとめ", "スクミズミコクロ", "ミズミコ", "ミコニャン", "とある画帖", "御坂美琴写真集９", "ジャンプ！", "シャワミコ"]

  test "page_urls_in_post":
    block:
      check page_urls_in_post(mode1_illusts[22]) == (8, @["https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p1_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p2_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p3_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p4_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p5_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p6_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p7_master1200.jpg"])


  test "change_url_to_full":
    block:
      check change_url_to_full("https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg") == "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg"

  test "process_user_url":
    block:
      check process_user_url("https://www.pixiv.net/en/users/2232374") == ("2232374", "1")
      check process_user_url("2232374") == ("2232374", "1")

  test "process_artwork_url":
    block:
      check process_artwork_url("https://www.pixiv.net/en/artworks/76695217") == ("76695217", "2")
      check process_artwork_url("76695217") == ("76695217", "2")


suite "data.Gallery":

  var gdata = initGallery(1, &"{KONEKODIR}/2232374/")

  test "initGallery":
    block:
      check gdata.raw == nil
      check gdata.current_page_num == 1
      check gdata.main_path == &"{KONEKODIR}/2232374/"

  test "set_raw":
    block:
      gdata.raw = mode1
      check gdata.raw != nil
      check gdata.all_pages_cache["1"] == mode1

      check gdata.current_page_num == 1
      check gdata.main_path == &"{KONEKODIR}/2232374/"

  test "download_path":
    block:
      check gdata.download_path == &"{KONEKODIR}/2232374/1"

  test "current_illusts":
    block:
      check gdata.current_illusts.len == 30

  test "post_json":
    block:
      check gdata.post_json(0) == """{"id":81547984,"title":"みこっちゃん","type":"illust","image_urls":{"square_medium":"https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/14/06/45/24/81547984_p0_square1200.jpg","medium":"https://i.pximg.net/c/540x540_70/img-master/img/2020/05/14/06/45/24/81547984_p0_master1200.jpg","large":"https://i.pximg.net/c/600x1200_90_webp/img-master/img/2020/05/14/06/45/24/81547984_p0_master1200.jpg"},"caption":"( ˘ω˘ )ﾃﾞｽ","restrict":0,"user":{"id":2232374,"name":"raika9","account":"raika9","profile_image_urls":{"medium":"https://i.pximg.net/user-profile/img/2016/06/30/03/20/52/11132477_4b836884eae72b4e90061719fd75180b_170.jpg"},"is_followed":true},"tags":[{"name":"とある科学の超電磁砲","translated_name":null},{"name":"とある魔術の禁書目録","translated_name":null},{"name":"御坂美琴","translated_name":null}],"tools":["CLIP STUDIO PAINT"],"create_date":"2020-05-14T06:45:24+09:00","page_count":1,"width":764,"height":1087,"sanity_level":2,"x_restrict":0,"series":null,"meta_single_page":{"original_image_url":"https://i.pximg.net/img-original/img/2020/05/14/06/45/24/81547984_p0.jpg"},"meta_pages":[],"total_view":8021,"total_bookmarks":2324,"is_bookmarked":false,"visible":true,"is_muted":false,"total_comments":54}""".parseJson

  test "artist_user_id":
    block:
      check gdata.artist_user_id(0) == 2232374

  test "image_id":
    block:
      check gdata.image_id(0) == 81547984

  test "cached_pages":
    block:
      check gdata.cached_pages == @["1"]

  test "next_url":
    block:
      check gdata.next_url == "https://app-api.pixiv.net/v1/user/illusts?user_id=2232374&filter=for_ios&type=illust&offset=30"

  test "first_img":
    block:
      check gdata.first_img == "みこっちゃん"

  test "page_num":
    block:
      check gdata.page_num == 1
      check gdata.page_num == gdata.current_page_num


suite "data.Image":
  var idata = initImage(mode2, "76695217")

  test "initImage":
    block:
      check idata.url == "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg"
      check idata.filename == "76695217_p0_master1200.jpg"
      check idata.artist_user_id == 2232374
      check idata.img_post_page_num == 0
      check idata.number_of_pages == 8
      check idata.page_urls == @["https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p1_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p2_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p3_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p4_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p5_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p6_master1200.jpg", "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p7_master1200.jpg"]
      check idata.downloaded_images == @["76695217_p0_master1200.jpg", "76695217_p1_master1200.jpg"]
      check idata.large_dir == "~/.local/share/koneko/cache/2232374/individual/76695217/".expandTilde

  test "image_filename":
    block:
      check idata.image_filename == "76695217_p0_master1200.jpg"

  test "filepath":
    block:
      check idata.filepath == &"{KONEKODIR}/2232374/individual/76695217/76695217_p0_master1200.jpg"

  test "next_img_url":
    block:
      check idata.next_img_url == "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p1_master1200.jpg"

  test "current_url":
    block:
      check idata.current_url == "https://i.pximg.net/c/600x1200_90_webp/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg"


suite "data.User":
  var udata = initUser(mode3, 1, &"{KONEKODIR}/following/", "2232374")

  test "initUser":
    block:
      check udata.page_num == 1
      check udata.main_path == &"{KONEKODIR}/following/"
      check udata.input == "2232374"

  test "update":
    block:
      check udata.next_url == "https://app-api.pixiv.net/v1/user/following?user_id=2232374&restrict=private&offset=30"
      check udata.ids_cache == {"1": @[219621, 1510169, 12612404, 8660134, 15063, 28245700, 33137265, 2702224, 24218478, 625051, 95391, 9427, 1193008, 1554775, 11103, 7309825, 5301174, 4316556, 10573236, 29362997, 809099, 82688, 15608555, 30803054, 18836733, 644670, 2397243, 14211481, 8092144, 8175661]}.toTable
      check udata.names_cache == {"1": @["畳と桧", "ざるつ", "春夫", "JAM", "肋兵器", "おてん!!!!!!!!", "saber", "sola7764", "￦ANKE", "ToY", "sigma99", "アマガイタロー", "望月けい", "米山舞", "にえあ@冬コミ新刊委託中です", "白萝炖黑兔", "Kelinch1", "三崎二式.N3", "ﾕｳｷ", "sunhyunそんひょん선현", "うまくち醤油", "Prime", "哦雅思密乃", "ホリセイ", "pattsk138", "DELF", "キンタ", "cookies", "Aluppia", "うにゃりすたー"]}.toTable
      check udata.profile_pic_urls.len == 30
      check udata.image_urls.len == 87

  test "download_path":
    block:
      check udata.download_path == &"{KONEKODIR}/following/22323741"

  test "artist_user_id":
    block:
      check udata.artist_user_id(0) == 219621

  test "names":
    block:
      check udata.names == @["畳と桧", "ざるつ", "春夫", "JAM", "肋兵器", "おてん!!!!!!!!", "saber", "sola7764", "￦ANKE", "ToY", "sigma99", "アマガイタロー", "望月けい", "米山舞", "にえあ@冬コミ新刊委託中です", "白萝炖黑兔", "Kelinch1", "三崎二式.N3", "ﾕｳｷ", "sunhyunそんひょん선현", "うまくち醤油", "Prime", "哦雅思密乃", "ホリセイ", "pattsk138", "DELF", "キンタ", "cookies", "Aluppia", "うにゃりすたー"]

  test "names_prefixed":
    block:
      check udata.names_prefixed == @["00\n                   畳と桧", "01\n                   ざるつ", "02\n                   春夫", "03\n                   JAM", "04\n                   肋兵器", "05\n                   おてん!!!!!!!!", "06\n                   saber", "07\n                   sola7764", "08\n                   ￦ANKE", "09\n                   ToY", "10\n                   sigma99", "11\n                   アマガイタロー", "12\n                   望月けい", "13\n                   米山舞", "14\n                   にえあ@冬コミ新刊委託中です", "15\n                   白萝炖黑兔", "16\n                   Kelinch1", "17\n                   三崎二式.N3", "18\n                   ﾕｳｷ", "19\n                   sunhyunそんひょん선현", "20\n                   うまくち醤油", "21\n                   Prime", "22\n                   哦雅思密乃", "23\n                   ホリセイ", "24\n                   pattsk138", "25\n                   DELF", "26\n                   キンタ", "27\n                   cookies", "28\n                   Aluppia", "29\n                   うにゃりすたー"]

  test "all_urls":
    block:
      check udata.all_urls.len == 117

  test "all_names":
    block:
      check udata.all_names == @["畳と桧", "ざるつ", "春夫", "JAM", "肋兵器", "おてん!!!!!!!!", "saber", "sola7764", "￦ANKE", "ToY", "sigma99", "アマガイタロー", "望月けい", "米山舞", "にえあ@冬コミ新刊委託中です", "白萝炖黑兔", "Kelinch1", "三崎二式.N3", "ﾕｳｷ", "sunhyunそんひょん선현", "うまくち醤油", "Prime", "哦雅思密乃", "ホリセイ", "pattsk138", "DELF", "キンタ", "cookies", "Aluppia", "うにゃりすたー", "81258221_p0_square1200", "81035530_p0_square1200", "80699629_p0_square1200", "78613317_p0_square1200", "74541047_p0_square1200", "72512314_p0_square1200", "78113353_p0_square1200", "77309367_p0_square1200", "77305517_p0_square1200", "80956202_p0_square1200", "79573047_p0_square1200", "79335561_p0_square1200", "81422477_p0_square1200", "80555468_p0_square1200", "79145744_p0_square1200", "80987017_p0_square1200", "80904535_p0_square1200", "80899986_p0_square1200", "79603234_p0_square1200", "79530224_p0_square1200", "78581098_p0_square1200", "81363682_p0_square1200", "81270363_p0_square1200", "81213886_p0_square1200", "50246878_p0_square1200", "50223367_p0_square1200", "43231172_p0_square1200", "77180657_p0_square1200", "74967427_p0_square1200", "74967394_p0_square1200", "78446413_p0_square1200", "75034396_p0_square1200", "66806885_p0_square1200", "80900186_p0_square1200", "80680801_p0_square1200", "80423566_p0_square1200", "80786439_p0_square1200", "79342948_p0_square1200", "78830672_p0_square1200", "81108823_p0_square1200", "80457352_p0_square1200", "78430684_p0_square1200", "81609513_p0_square1200", "81541593_p0_square1200", "81459961_p0_square1200", "77499932_p0_square1200", "76790778_p0_square1200", "75998778_p0_square1200", "81664872_p0_square1200", "81603032_p0_square1200", "81602973_p0_square1200", "78590221_p0_square1200", "78474483_p0_square1200", "76363757_p0_square1200", "81241007_p0_square1200", "81011738_p0_square1200", "80722852_p0_square1200", "81150911_p0_square1200", "80717346_p0_square1200", "79429474_p0_square1200", "76043556_p0_square1200", "75936667_p0_square1200", "69956757_p0_square1200", "78013455_p0_square1200", "66209081_p0_square1200", "53810308_p0_square1200", "81287716_p0_square1200", "80837899_p0_square1200", "79198662_p0_square1200", "76344408_p0_square1200", "76101063_p0_square1200", "76036041_p0_square1200", "78920807_p0_square1200", "76118660_p0_square1200", "76115853_p0_square1200", "80492957_p0_square1200", "77970884_p0_square1200", "76547709_p0_square1200", "79708221_p0_square1200", "76623178_p0_square1200", "74653820_p0_square1200", "81542404_p0_square1200", "80414334_p0_square1200", "79663557_p0_square1200", "79028150_p0_square1200", "79027961_p0_square1200", "79027291_p0_square1200"]

  test "splitpoint":
    block:
      check udata.splitpoint == 30

  test "first_img":
    block:
      check udata.first_img == "畳と桧"
