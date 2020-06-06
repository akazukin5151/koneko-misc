use std::fs;
use std::thread;
use std::string::String;
use std::convert::TryInto;
use std::ops::RangeInclusive;
use std::sync::mpsc::{channel, Receiver, Sender};

extern crate cmd_lib;
extern crate dirs_next;

fn producer(sender: Sender<String>, files: &Vec<String>) {
    for file in files {
        let sender = sender.clone();
        sender.send(file.to_string()).unwrap();
    }
    drop(sender);
}

fn consumer(tracker: Receiver<String>, image: Sender<String>) {
    let mut downloaded: Vec<i32> = vec![];
    let mut paths: Vec<String> = vec![];
    let orders: RangeInclusive<i32> = 0..=29;

    consumer_loop(&tracker, &image, &mut downloaded, &mut paths, 0, &orders);
}

fn consumer_loop(
    tracker: &Receiver<String>,
    image: &Sender<String>,
    mut downloaded: &mut Vec<i32>,
    mut paths: &mut Vec<String>,
    number: i32,
    orders: &RangeInclusive<i32>,
) {
    if downloaded.iter().any(|&x| x == number) {
        // Send to display channel
        image.send(int_to_file(&number, paths)).unwrap();

        // Inspect int list with next accepted number
        downloaded.retain(|&x| x != number);
        consumer_loop(
            &tracker,
            &image,
            &mut downloaded,
            &mut paths,
            number + 1,
            orders,
        );
    }

    // On receiving a completed download, store the filename number
    let msg = &tracker.recv();
    match msg {
        Ok(img) => {
            downloaded.push(file_to_int(img));
            paths.push(img.to_string());
            consumer_loop(
                &tracker,
                &image,
                &mut downloaded,
                &mut paths,
                number,
                orders,
            );
        }
        Err(_) => {}
    }
}

fn int_to_file(num: &i32, paths: &Vec<String>) -> String {
    paths
        .iter()
        .filter(|x| file_to_int(x) == *num)
        .nth(0)
        .unwrap()
        .to_string()
}

fn file_to_int(x: &String) -> i32 {
    x.split("/")
        .last()
        .unwrap()
        .split("_")
        .nth(0)
        .unwrap()
        .parse::<i32>()
        .unwrap()
}

fn display(image: Receiver<String>) {
    let leftshifts: [i32; 5] = [0, 20, 38, 56, 74];
    let rowspaces: [i32; 2] = [0, 9];
    let cmd = "kitty +kitten icat --silent --place=";

    loop {
        let msg = image.recv();
        match msg {
            Ok(img) => {
                let num: usize = file_to_int(&img).try_into().unwrap();
                let x = num.rem_euclid(5);
                let y = (num / 5).rem_euclid(2);

                if num == 10 {
                    println!("{}", "\n".repeat(40));
                } else if num == 20 {
                    println!("{}", "\n".repeat(18));
                }

                #[rustfmt::skip]
                let _ = cmd_lib::run_cmd!("{}17x17@{}x{} '{}'", cmd,
                                          leftshifts[x], rowspaces[y], img);
            }
            Err(_) => break,
        }
    }
}

fn main() {
    let homedir = dirs_next::home_dir().unwrap();
    let path = homedir.join(".local/share/koneko/cache/2232374/1");
    let files = fs::read_dir(path).unwrap();

    let mut filesvec = vec![];
    for file in files {
        filesvec.push(String::from(
            file.unwrap().path().as_path().to_str().unwrap(),
        ))
    }

    let (tracker_s, tracker_r) = channel();
    let (image_s, image_r) = channel();

    thread::spawn(move || {
        producer(tracker_s, &filesvec);
    });

    thread::spawn(move || {
        consumer(tracker_r, image_s);
    });

    display(image_r);
}
