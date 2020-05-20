import
  os,
  pure,
  json,
  tables,
  strutils,
  strformat,
  zero_functional

const KONEKODIR = "~/.local/share/koneko/cache".expandTilde

type
  Gallery = ref GalleryObj
  GalleryObj = object
    raw: JsonNode
    all_pages_cache*: Table[string, JsonNode]
    current_page_num*: int
    main_path*: string

func initGallery*(current_page_num: int, main_path: string): Gallery =
  ## Use this function to instantiate a new Gallery class
  new(result)
  result.current_page_num = current_page_num
  result.main_path = main_path

func `raw=`*(self: Gallery, raw: JsonNode): void {.inline.} =
  ## Setter of the raw attribute
  ## Directly modifies the reference to the Gallery object, returns nothing
  self.raw = raw
  self.all_pages_cache = {self.current_page_num.intToStr: raw}.toTable

func raw*(self: Gallery): JsonNode {.inline.} =
  ## Getter of the raw attribute
  return self.raw

func download_path*(self: Gallery): string =
  return self.main_path & self.current_page_num.intToStr

func current_illusts*(self: Gallery): JsonNode =
  return self.all_pages_cache[self.current_page_num.intToStr]["illusts"]

func post_json*(self: Gallery, post_number: int): JsonNode =
  return self.current_illusts[post_number]

func artist_user_id*(self: Gallery, post_number: int): int =
  return self.post_json(post_number)["user"]["id"].getInt

func image_id*(self: Gallery, number: int): int =
  return self.current_illusts[number]["id"].getInt

func cached_pages*(self: Gallery): seq[string] =
  for key in self.all_pages_cache.keys:
    result.add(key)

func next_url*(self: Gallery): string =
  return self.all_pages_cache[self.current_page_num.intToStr]["next_url"].getStr

func first_img*(self: Gallery): string =
  return post_titles_in_page(self.current_illusts)[0]

func page_num*(self: Gallery): int =
  ## Just a wrapper for init_download()
  return self.current_page_num



type
  Image = ref ImageObj
  ImageObj = object
    raw: JsonNode
    url*: string
    filename*: string
    artist_user_id*: int
    img_post_page_num*: int
    number_of_pages*: int
    page_urls*: seq[string]
    downloaded_images*: seq[string]
    large_dir*: string

proc initImage*(raw: JsonNode, image_id: string): Image =
  new(result)
  result.raw = raw
  # If you look carefully at main.py, raw is passed in as raw["illust"]
  let url = url_given_size(raw["illust"], "large")
  result.url = url
  result.filename = split_backslash_last(url)
  result.artist_user_id = raw["illust"]["user"]["id"].getInt
  result.img_post_page_num = 0

  let (number_of_pages, page_urls) = page_urls_in_post(raw["illust"], "large")
  result.number_of_pages = number_of_pages
  result.page_urls = page_urls
  if result.number_of_pages == 1:
      result.downloaded_images = @[]
      result.large_dir = &"{KONEKODIR}/{result.artist_user_id}/individual/"
  else:
      result.downloaded_images = page_urls[..1] --> map(split_backslash_last(it))
      # So it won't be duplicated later
      result.large_dir = &"{KONEKODIR}/{result.artist_user_id}/individual/{image_id}/"

func image_filename*(self: Image): string =
  return self.downloaded_images[self.img_post_page_num]

func filepath*(self: Image): string =
  return self.large_dir & self.image_filename

func next_img_url*(self: Image): string =
  return self.page_urls[self.img_post_page_num + 1]

func current_url*(self: Image): string =
  self.page_urls[self.img_post_page_num]



type
  User = ref UserObj
  UserObj = object
    raw: JsonNode
    ids_cache*: Table[string, seq[int]]
    names_cache*: Table[string, seq[string]]
    next_url*: string
    profile_pic_urls*: seq[string]
    image_urls*: seq[string]
    page_num*: int
    main_path*: string
    input*: string

func user_id(json: JsonNode): int =
  json["user"]["id"].getInt

func user_name(json: JsonNode): string =
  json["user"]["name"].getStr

func user_profile_pic(json: JsonNode): string =
  json["user"]["profile_image_urls"]["medium"].getStr

func update*(self: User, raw: JsonNode): void =
  self.raw = raw
  self.next_url = raw["next_url"].getStr
  let page = self.raw["user_previews"]

  let ids = page --> map(user_id(it))
  self.ids_cache[self.page_num.intToStr] = ids

  let names = page --> map(user_name(it))
  self.names_cache[self.page_num.intToStr] = names

  self.profile_pic_urls = page --> map(user_profile_pic(it))

  for i in 0..<page.len:
    for j in 0..<page[i]["illusts"].len:
      self.image_urls.add(page[i]["illusts"][j]["image_urls"]["square_medium"].getStr)

proc initUser*(raw: JsonNode, page_num: int, main_path: string, user_or_id:string): User=
  new(result)
  result.page_num = page_num
  result.main_path = main_path
  result.input = user_or_id

  result.ids_cache = initTable[string, seq[int]]()
  result.names_cache = initTable[string, seq[string]]()
  result.update(raw)

func download_path*(self: User): string =
  return self.main_path & self.input & self.page_num.intToStr

func artist_user_id*(self: User, selected_user_num: int): int =
  return self.ids_cache[self.page_num.intToStr][selected_user_num]

func names*(self: User): seq[string] =
  return self.names_cache[self.page_num.intToStr]

func names_prefixed*(self: User): seq[string] =
  let names = self.names
  for index in 0..names.high:
    result.add prefix_artist_name(names[index], index)

func all_urls*(self: User): seq[string] =
  return self.profile_pic_urls & self.image_urls

func all_names*(self: User): seq[string] =
  let preview_names_ext = self.image_urls --> map(split_backslash_last(it))

  var preview_names: seq[string]
  for x in preview_names_ext:
    preview_names.add(x.split(".")[0])

  return self.names & preview_names

func splitpoint*(self: User): int =
  return self.profile_pic_urls.len

func first_img*(self: User): string =
  return self.all_names[0]

