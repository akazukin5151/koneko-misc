import
  strformat,
  strutils,
  os,
  tables,
  sequtils,
  re,
  json

proc split_backslash_last*(str: string): string =
    return str.split("/")[^1]

proc generate_filepath*(filename: string): string =
    return &"{getHomeDir()}/Downloads/{filename}"

proc prefix_filename*(old_name: string, new_name: string, number: int): string =
    let img_ext = old_name.split(".")[^1]
    let number_prefix = intToStr(number).align(3, char(0))
    return &"{number_prefix}_{new_name}.{img_ext}"

proc prefix_artist_name*(name: string, number: int): string =
    let number_prefix = intToStr(number).align(2, char(0))
    return &"{number_prefix}\n{' '.repeat(19)}{name}"

proc print_multiple_imgs*(illusts_json: JsonNode) =
    for (index, json) in illusts_json.pairs:
        let pages = json["page_count"].getInt
        if pages > 1:
            echo(&"#{index} has {pages} pages")
    echo("")

proc url_given_size*(post_json: JsonNode, size: string): string =
    return post_json["image_urls"][size].getStr

proc post_title*(current_page_illusts: JsonNode, post_number: int): string =
    return current_page_illusts[post_number]["title"].getStr

proc medium_urls*(current_page_illusts: JsonNode): auto =
    for i in current_page_illusts:
      return url_given_size(i, size="square-medium") # FIXME

proc page_urls_in_post*(post_json: JsonNode, size: string = "medium"): (int, seq[string]) =
  let number_of_pages = post_json["page_count"].getInt
  var page_urls: seq[string]
  if number_of_pages > 1:
    echo &"Page 1/{number_of_pages}"
    let list_of_pages = post_json["meta_pages"]
    for i in 0..number_of_pages:
      page_urls.add(url_given_size(list_of_pages[i], size))
  else:
    page_urls = @[url_given_size(post_json, size)]

  result = (number_of_pages, page_urls)

proc change_url_to_full*(png: bool = false, url: string): string =
    var newurl = url.replace(re"_master\d+")
    newurl = newurl.replace(re"c\/\d+x\d+_\d+_\w+\/img-master", "img-original")

    # If it doesn't work, try changing to png
    if png:
        newurl = newurl.replace("jpg", "png")
    return url

#[
echo(split_backslash_last("s/das/24451"))
echo(generate_filepath("hi"))
echo(prefix_filename("hi.jpg", "hello", 2))
echo(prefixArtistName("raika9", 2))
printMultipleImgs({"1": {"page_count": 2}.totable}.totable)
echo urlGivenSize({"image_urls": {"square-medium": "www"}.totable}.totable, "square-medium")
echo postTitle(@[{"title": "hi"}.totable], 0)
echo mediumUrls(@[{"image_urls": {"square-medium": "www"}.totable}.totable])

echo changeUrlToFull(false, "https://i.pximg.net/img-master/img/2019/06/02/15/12/13/75023234_p3_master1200.jpg")
]#
