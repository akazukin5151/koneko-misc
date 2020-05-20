include("./pure.jl")
using .pure
using Test, Lazy, LazyJSON

const io = open("mode1.json", "r")
const mode1s = read(io)
const mode1 = LazyJSON.value(mode1s)
close(io)
const mode1_illusts = mode1["illusts"]

@test split_backslash_last("one/two/three") == "three"
@test generate_filepath("myfile") == "$(homedir())/Downloads/myfile"
@test prefix_filename("one/two/three.png", "four", 1) == "001_four.png"
@test prefix_artist_name("name", 1) == "01\n                   name"

const fnm = [find_number_map(x, y)
             for y in 1:6
             for x in 1:5]
@test fnm == [i for i in 0:29]

# Actually not broken
@test_broken print_multiple_imgs(mode1_illusts)  # #23 has 8 pages

@test url_given_size(mode1["illusts"][1], "medium") == "https://i.pximg.net/c/540x540_70/img-master/img/2020/05/14/06/45/24/81547984_p0_master1200.jpg"
@test post_title(mode1_illusts, 1) == "みこっちゃん"

@test medium_urls(mode1_illusts) == ["https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/14/06/45/24/81547984_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/12/06/36/27/81501385_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/10/23/10/38/81468125_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/09/04/31/04/81416496_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/07/05/48/03/81368866_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/05/04/05/17/46/81276257_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/04/20/04/52/26/80923496_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/04/11/01/49/35/80701898_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/03/10/04/07/08/80017594_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/02/29/19/09/35/79799236_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/02/22/21/21/50/79658392_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/02/17/05/31/08/79549991_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/01/10/21/50/56/78823485_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2020/01/01/02/50/56/78628383_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/12/21/20/13/12/78403815_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/12/20/03/00/33/78378594_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/12/08/19/09/16/78201587_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/11/14/00/47/58/77804404_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/31/06/25/38/77565309_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/24/22/50/31/77460464_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/18/06/06/27/77347697_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/10/02/07/26/09/77068750_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/09/09/04/32/38/76695217_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/09/01/01/39/35/76561671_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/08/08/04/11/57/76138362_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/27/16/34/45/75933779_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/20/02/29/47/75810852_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/13/17/12/09/75698678_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/07/06/17/40/44/75579060_p0_square1200.jpg", "https://i.pximg.net/c/540x540_10_webp/img-master/img/2019/06/29/09/44/52/75457783_p0_square1200.jpg"]

@test post_titles_in_page(mode1_illusts) == ["みこっちゃん", "おりじなる", "0510", "5.3", "おりじなる", "ミコ誕オメ画！", "5.2", "5.1", "310", "Midnight Sun", "222", "バレンタイン", "祝！！！", "あけましておめでとうございます", "ミコサンタ", "C97告知", "ミコバニー", "たちかわ楽市2019仕様4人組", "ハロミコ", "夏服", "御坂美琴写真集１０用", "常盤台中学指定体操服改", "ツイッターまとめ", "スクミズミコクロ", "ミズミコ", "ミコニャン", "とある画帖", "御坂美琴写真集９", "ジャンプ！", "シャワミコ"]

@test page_urls_in_post(mode1_illusts[23]) == (8, ["https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p1_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p2_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p3_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p4_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p5_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p6_master1200.jpg", "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p7_master1200.jpg"])

@test change_url_to_full("https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p0_master1200.jpg") == "https://i.pximg.net/c/540x540_70/img-master/img/2019/09/09/04/32/38/76695217_p0.jpg"

@test process_user_url("https://www.pixiv.net/en/users/2232374") == ("2232374", "1")
@test process_user_url("2232374") == ("2232374", "1")
@test process_artwork_url("https://www.pixiv.net/en/artworks/76695217") == ("76695217", "2")
@test process_artwork_url("76695217") == ("76695217", "2")
