import
  json,
  tables,
  strutils,
  strformat,
  os,
  zero_functional,
  pure

const KONEKODIR = "~/.local/share/koneko/cache".expandTilde


type Gallery = object
  raw: JsonNode
  all_pages_cache: Table[string, JsonNode]

func initGallery(raw: JsonNode): Gallery =
  ## Use this function to instantiate a new Gallery class
  result.raw = raw
  result.all_pages_cache = {"1": raw}.toTable

func current_page(self: Gallery, current_page_num: int = 1): JsonNode =
  self.all_pages_cache[current_page_num.intToStr]

func current_illusts(self: Gallery, current_page_num: int = 1): JsonNode =
  self.current_page(current_page_num)["illusts"]

proc titles(self: Gallery): seq[string] =
  for i in 0..self.current_illusts.len:
    result.add(post_title(self.current_illusts[i], i))

func post_json(self: Gallery, current_page_num: int, post_number: int): JsonNode =
  self.current_illusts(current_page_num)[post_number]

func image_id(self: Gallery, current_page_num: int, post_number: int): string =
  self.post_json(current_page_num, post_number)["id"].getStr

func cached_pages(self: Gallery): seq[string] =
  for key in self.all_pages_cache.keys:
    result.add(key)

func next_url(self: Gallery, current_page_num: int): string =
  self.current_page(current_page_num)["next_url"].getStr



type Image = object
  raw: JsonNode
  url: string
  filename: string
  artist_user_id: string
  img_post_page_num: int
  number_of_pages: int
  page_urls: seq[string]
  downloaded_images: seq[string]
  large_dir: string

proc initImage(raw: JsonNode, image_id: string): Image =
  result.raw = raw
  let url = url_given_size(raw, "large")
  result.url = url
  result.filename = split_backslash_last(url)
  result.artist_user_id = raw["user"]["id"].getStr
  result.img_post_page_num = 0

  let (number_of_pages, page_urls) = page_urls_in_post(raw, "large")
  result.number_of_pages = number_of_pages
  result.page_urls = page_urls
  if result.number_of_pages == 1:
      result.downloaded_images = @[]
      result.large_dir = &"{KONEKODIR}/{result.artist_user_id}/individual/"
  else:
      result.downloaded_images = page_urls[..1] --> map(split_backslash_last(it))
      # So it won't be duplicated later
      result.large_dir = &"{KONEKODIR}/{result.artist_user_id}/individual/{image_id}/"

func image_filename(self: Image): string =
  self.downloaded_images[self.img_post_page_num]

func filepath(self: Image): string =
  self.large_dir & self.image_filename

func next_img_url(self: Image): string =
  self.page_urls[self.img_post_page_num + 1]

func current_url(self: Image): string =
  self.page_urls[self.img_post_page_num]



type User = object
  raw: JsonNode
  ids_cache: Table[string, seq[string]]
  names_cache: Table[string, seq[string]]
  next_url: string
  page: JsonNode
  profile_pic_urls: seq[string]
  image_urls: seq[string]

func user_id(json: JsonNode): string =
  json["user"]["id"].getStr

func user_name(json: JsonNode): string =
  json["user"]["name"].getStr

func user_profile_pic(json: JsonNode): string =
  json["user"]["profile_image_urls"]["medium"].getStr

proc update(self: User, raw: JsonNode, page_num: int): User =
  result.raw = raw
  result.next_url = raw["next_url"].getStr
  let page = result.raw["user_previews"]

  let ids = page --> map(user_id(it))
  result.ids_cache[page_num.intToStr] = ids

  let names = page --> map(user_name(it))
  result.names_cache[page_num.intToStr] = names

  result.profile_pic_urls = page --> map(user_profile_pic(it))

  for i in 0..page.len:
    for j in 0..page[i]["illusts"].len:
      result.image_urls.add(page[i]["illusts"][j]["image_urls"]["square_medium"].getStr)

proc initUser(raw: JsonNode, page_num: int): User =
  result.ids_cache = initTable[string, seq[string]]()
  result.names_cache = initTable[string, seq[string]]()
  result.update(raw, page_num)

func artist_user_id(self: User, page_num: int, selected_user_num: int): string =
  self.ids_cache[page_num.intToStr][selected_user_num]

func names(self: User, page_num: int): seq[string] =
  self.names_cache[page_num.intToStr]

func all_urls(self: User): seq[string] =
  self.profile_pic_urls & self.image_urls

proc all_names(self: User, page_num: int): seq[string] =
  let preview_names_ext = self.image_urls --> map(split_backslash_last(it))

  var preview_names: seq[string]
  for x in preview_names_ext:
    preview_names.add(x.split(".")[0])

  self.names(page_num) & preview_names

func splitpoint(self: User): int =
  self.profile_pic_urls.len

