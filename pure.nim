import
  os,
  re,
  json,
  options,
  strutils,
  strformat

func split_backslash_last*(str: string): string =
  return str.split("/")[^1]

proc generate_filepath*(filename: string): string =
  return &"{getHomeDir()}Downloads/{filename}"

func prefix_filename*(old_name: string, new_name: string, number: int): string =
  let
    img_ext = old_name.split(".")[^1]
    number_prefix = number.intToStr.align(3, '0')
  return &"{number_prefix}_{new_name}.{img_ext}"

func prefix_artist_name*(name: string, number: int): string =
  let number_prefix = number.intToStr.align(2, '0')
  return &"{number_prefix}\n{' '.repeat(19)}{name}"

proc find_number_map*(x, y: int): Option[int] =
  #[ Translates 1-based-index coordinates into (0-) indexable number
  5 columns and 6 rows == 30 images
  -1 accounts for the input being 1-based-index but python being 0-based
  mod 5: x is cyclic for every 5
  +5y: adding a 5 for every row 'moves one square down' on the 5x6 grid

  >>> a = [find_number_map(x,y) for y in range(1,7) for x in range(1,6)]
  >>> assert a == list(range(30))
  ]#
  if not (1 <= x and x <= 5 and 1 <= y and y <= 6):
    echo "Invalid number!"
    return none(int)
  return some(((x - 1) mod 5) + (5 * (y - 1)))

proc print_multiple_imgs*(illusts_json: JsonNode): auto =
  var i = 0
  while i < illusts_json.len:
    var pages = illusts_json[i]["page_count"].getInt
    if pages > 1:
      echo &"#{i} has {pages} pages"
    i += 1
  echo ""

func url_given_size*(post_json: JsonNode, size: string): string =
  return post_json["image_urls"][size].getStr

func post_title*(current_page_illusts: JsonNode, post_number: int): string =
  return current_page_illusts[post_number]["title"].getStr

func medium_urls*(current_page_illusts: JsonNode): seq[string] =
  for i in current_page_illusts:
    result.add(i["image_urls"]["square_medium"].getStr)

func post_titles_in_page*(current_page_illusts: JsonNode): seq[string] =
  for i in 0..<current_page_illusts.len:
    result.add(post_title(current_page_illusts, i))

proc page_urls_in_post*(post_json: JsonNode, size: string = "medium"): (int, seq[string]) =
  let number_of_pages = post_json["page_count"].getInt
  var page_urls: seq[string]
  if number_of_pages > 1:
    echo &"Page 1/{number_of_pages}"
    let list_of_pages = post_json["meta_pages"]
    for i in 0..<number_of_pages:
      page_urls.add(url_given_size(list_of_pages[i], size))
  else:
    page_urls = @[url_given_size(post_json, size)]

  result = (number_of_pages, page_urls)

func change_url_to_full*(url: string, png: bool = false): string =
  var newurl = url.replace(re"_master\d+")
  newurl = newurl.replace(re"c\/\d+x\d+_\d+_\w+\/img-master", "img-original")

  # If it doesn't work, try changing to png
  if png:
      newurl = newurl.replace("jpg", "png")
  return url

func process_user_url*(url_or_id: string): (string, string) =
  var user_input: string
  if "users" in url_or_id:
    if "\\" in url_or_id:
      user_input = split_backslash_last(url_or_id).split("\\")[^1][1..^1]
    else:
      user_input = split_backslash_last(url_or_id)
  else:
    user_input = url_or_id
  return (user_input, "1")

func process_artwork_url*(url_or_id: string): (string, string) =
  var user_input: string
  if "artworks" in url_or_id:
    user_input = split_backslash_last(url_or_id).split("\\")[0]
  elif "illust_id" in url_or_id:
    user_input = url_or_id.findall(re"&illust_id.*")[0].split("=")[^1]
  else:
    user_input = url_or_id
  return (user_input, "2")
