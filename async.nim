import
  os,
  sugar,
  random,
  strutils,
  sequtils,
  strformat

# Global
var
  tracker_chan: Channel[string]
  image_chan: Channel[string]
tracker_chan.open()
image_chan.open()

proc index[T](s: seq[T], item: T): int =
  var i = 0
  while i < s.len:
    if s[i] == item:
      return i
    i += 1
  return -1

proc display() =
  ## Equivalent to lscat
  let
    args = &"--align=left --silent --place=15x15@"
    left_shifts = @[2,20,38,56,74]
    rowspaces = @[0, 9]

  while true:
    let image_path = image_chan.recv()
    if image_path == "Done":
      break

    let
      index: int = image_path.split("/")[^1][..2].parseInt
      x = left_shifts[index mod 5]
      y = rowspaces[index div 5 mod 2]

    if index == 10:
      echo "\n".repeat(40)
    elif index == 20:
      echo "\n".repeat(18)

    discard execShellCmd(&"kitty +kitten icat {args}{x}x{y} '{image_path}'")


proc inspect(order: seq[int], counter: int, downloaded: seq[string]):(int, seq[string]) =
  ## Equivalent to Tracker._inspect()
  let next_num = order[counter].intToStr.align(3, '0')
  var downloaded_new = downloaded
  var numlist = collect(newSeq):
    for file in downloaded:
      file.extractFilename[..2]

  if next_num in numlist:
    let pic = downloaded[numlist.index(next_num)]
    # Display pic
    image_chan.send(pic)

    # Remove
    downloaded_new = downloaded.filter(x => x != pic)
    numlist = numlist.filter(x => x != next_num)

    if downloaded_new.len != 0:
      return inspect(order, counter+1, downloaded_new)
  return (counter, downloaded_new)


proc producer(files: seq[string]): void =
  ## Simulate downloading, equivalent to downloadr()
  for file in files:
    tracker_chan.send(file)
    sleep(rand(3))
  tracker_chan.send("Done")
  image_chan.send("Done")

proc consumer(order: seq[int]): void =
  ## Callback for when one image finishes downloading
  ## Equivalent to Tracker class without _inspect()
  var
    downloaded: seq[string]
    counter = 0

  while true:
    let message = tracker_chan.recv()  # Blocking
    downloaded.add message
    if message == "Done":
      break

    (counter, downloaded) = inspect(order, counter, downloaded)


proc main(files: seq[TaintedString], order: seq[int]) =
  var worker: Thread[seq[string]]
  createThread(worker, producer, files)
  var worker2: Thread[seq[int]]
  createThread(worker2, consumer, order)
  display()
  worker.joinThread()
  worker2.joinThread()


when isMainModule:
  var files = collect(newSeq):
        for _, path in walkDir("~/.local/share/koneko/cache/2232374/1".expandTilde):
          path

  let params = commandLineParams()

  discard execShellCmd("clear")
  import algorithm
  if params.len != 0 and "d" in params[0]:
    echo "Simulating when all pics are downloaded"
    sleep(1000)

    files.sort()

    proc all_downloaded(files: seq[string]): void =
      for file in files:
        image_chan.send(file)
      image_chan.send("Done")

    var worker: Thread[seq[string]]
    createThread(worker, all_downloaded, files)

    display()

  else:
    echo "Simulating displaying each pic as they finish downloading"
    sleep(1000)

    let order = collect(newSeq):
          for i in 0..29:
            i

    randomize()
    files.shuffle
    main(files, order)

tracker_chan.close()
image_chan.close()
