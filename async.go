package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"math/rand"
	"os/exec"
	"os/user"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

// Functions that I shouldn't need to write
func index(s []string, item string) int {
	i := 0
	for i < len(s) {
		if s[i] == item {
			return i
		}
		i += 1
	}
	return -1
}

// What kind of language doesn't have  "if X in Y"?
func contains(arr []string, str string) bool {
	for _, a := range arr {
		if a == str {
			return true
		}
	}
	return false
}

// Or "if X not in Y"?
func filter(ss []string, test func(string) bool) (ret []string) {
	for _, s := range ss {
		if test(s) {
			ret = append(ret, s)
		}
	}
	return
}

// Send only channel
func producer(tracker chan<- string, images []string) {
	for _, image := range images {
		tracker <- image
	}
	close(tracker)
}

// Receive only channel
func consumer(tracker <-chan string, image_chan chan string) {
	var downloaded []string
	counter := 0
	//Temp
	var order []int
	for i := 0; i <= 29; i++ {
		order = append(order, i)
	}

	for {
		msg, ok := <-tracker
		if ok == false {
			break
		} else {
			downloaded = append(downloaded, msg)
			counter, downloaded = inspect(order, counter, downloaded, image_chan)
		}
	}
}

func inspect(order []int, counter int, downloaded []string, image_chan chan<- string) (int, []string) {
	next_num := fmt.Sprintf("%03d", order[counter])
	downloaded_new := downloaded
	var numlist []string
	for _, file := range downloaded {
		numlist = append(numlist, file[0:3])
	}

	if contains(numlist, next_num) {
		pic := downloaded[index(numlist, next_num)]
		// Display pic
		image_chan <- pic

		// Remove
		not_pic := func(s string) bool { return s != pic }
		not_next_num := func(s string) bool { return s != next_num }

		downloaded_new = filter(downloaded, not_pic)
		numlist = filter(numlist, not_next_num)

		if len(downloaded_new) != 0 {
			return inspect(order, counter+1, downloaded_new, image_chan)
		} else {
			return counter + 1, downloaded_new
		}
	}
	return counter, downloaded_new
}

// Receive only
func display(image_chan <-chan string) {
	align := "--align=left"
	silent := "--silent"
	left_shifts := []int{2, 20, 38, 56, 74}
	rowspaces := []int{0, 9}
	for i := 0; i <= 30; i++ {
		select {
		case image_path, _ := <-image_chan:
			// "What should we name the string to int function? Atoi."
			number, _ := strconv.Atoi(image_path[0:3])

			// Not a single symbol, (((((((functions) everywhere), is)) this)) lisp?)
			number_mod_5 := int(math.Mod(float64(number), 5))
			x := left_shifts[number_mod_5]
			number_int_div_5_mod_2 := int(math.Mod(float64(int(number/5)), 2))
			y := rowspaces[number_int_div_5_mod_2]

			// "What about int to string function? Itoa." Brilliant
			place := "--place=15x15@" + strconv.Itoa(x) + "x" + strconv.Itoa(y)
			path := "/home/twenty/.local/share/koneko/cache/2232374/1/" + image_path

			if number == 10 {
				fmt.Println(strings.Repeat("\n", 40))
			} else if number == 20 {
				fmt.Println(strings.Repeat("\n", 18))
			}

			exec.Command("kitty", "+kitten", "icat", align, silent, place, path).Run()

		default:
			time.Sleep(1 * time.Second)
		}
	}
}

func main() {
	fmt.Println("\033[H\033[2J") // Clear the terminal
	tracker := make(chan string, 29)
	image_chan := make(chan string, 29)

	var images []string
	usr, _ := user.Current()
	dir := usr.HomeDir
	files, _ := ioutil.ReadDir(filepath.Join(dir, ".local/share/koneko/cache/2232374/1"))
	for _, file := range files {
		images = append(images, file.Name())
	}

	// What an absolute ugly way to shuffle an array...
	rand.Shuffle(29, func(i, j int) {
		images[i], images[j] = images[j], images[i]
	})

	go producer(tracker, images)
	go consumer(tracker, image_chan)
	display(image_chan)
}
