module pure

export
    split_backslash_last,
    generate_filepath,
    prefix_filename,
    prefix_artist_name,
    find_number_map,
    print_multiple_imgs,
    url_given_size,
    post_title,
    medium_urls,
    post_titles_in_page,
    page_urls_in_post,
    change_url_to_full,
    process_user_url,
    process_artwork_url

function split_backslash_last(string)
    return split(string, '/')[end]
end

function generate_filepath(filename)
    return "$(homedir())/Downloads/$filename"
end

function prefix_filename(old_name, new_name, number)
    img_ext = split(old_name, ".")[end]
    number_prefix = lpad(number, 3, "0")
    new_file_name = "$(number_prefix)_$(new_name).$img_ext"
    return new_file_name
end

function prefix_artist_name(name, number)
    number_prefix = lpad(number, 2, "0")
    new_file_name = "$number_prefix\n$(" " ^ 19)$name"
    return new_file_name
end

function find_number_map(x, y)
    """Translates 1-based-index coordinates into (0-) indexable number
    5 columns and 6 rows == 30 images
    -1 accounts for the input being 1-based-index but python being 0-based
    mod 5: x is cyclic for every 5
    +5y: adding a 5 for every row 'moves one square down' on the 5x6 grid

    >>> a = [find_number_map(x,y) for y in range(1,7) for x in range(1,6)]
    >>> assert a == list(range(30))
    """
    # In brackets: the accepted ranges for 5x6 grid
    if !(1 <= x <= 5 && 1 <= y <= 6)
        println("Invalid number!")
        return false
    end
    return ((x - 1) % 5) + (5 * (y - 1))
end


function print_multiple_imgs(illusts_json)
    for (index, post) in enumerate(illusts_json)
        pages = post["page_count"]
        if pages > 1
            print("#$index has $pages pages, ")
        end
    end
    println("")
end


function url_given_size(post_json, size)
    """
    size : str
        One of: ("square-medium", "medium", "large")
    """
    return post_json["image_urls"][size]
end


function post_title(current_page_illusts, post_number)
    return current_page_illusts[post_number]["title"]
end


function medium_urls(current_page_illusts)
    urls = map(x -> url_given_size(x, "square_medium"), current_page_illusts)
    return urls
end


function post_titles_in_page(current_page_illusts)
    titles = map(x -> post_title(current_page_illusts, x), 1:length(current_page_illusts))
    return titles
end


function page_urls_in_post(post_json, size="medium")
    """Get the number of pages and each of their urls in a multi-image post."""
    number_of_pages = post_json["page_count"]
    if number_of_pages > 1
        println("Page 1/$number_of_pages")
        list_of_pages = post_json["meta_pages"]
        page_urls = [url_given_size(list_of_pages[i], size)
                    for i in 1:number_of_pages]
        #for i in 1:number_of_pages
        #    append!(page_urls, url_given_size(list_of_pages[i], size))
        #end
    else
        page_urls = [url_given_size(post_json, size)]
    end

    return number_of_pages, page_urls
end


function change_url_to_full(url::String, png=false)
    """
    The 'large' resolution url isn't the largest. This uses changes the url to
    the highest resolution available
    """
    url = replace(url, r"_master\d+" => "")
    url = replace(url, r"c\/\d+x\d+_\d+_\w+\/img-master" => "img-original")

    # If it doesn't work, try changing to png
    if png
        url = replace(url, "jpg" => "png")
    end
    return url
end

function change_url_to_full(post_json, png=false)
    """
    The 'large' resolution url isn't the largest. This uses changes the url to
    the highest resolution available
    """
    if post_json
        url = url_given_size(post_json, "large")
    end
    url = replace(url, r"_master\d+" => "")
    url = replace(url, r"c\/\d+x\d+_\d+_\w+\/img-master" => "img-original")

    # If it doesn't work, try changing to png
    if png
        url = replace(url, "jpg" => "png")
    end
    return url
end

function process_user_url(url_or_id)
    if occursin("users", url_or_id)
        if occursin("\\", url_or_id)
            user_input = split(split_backslash_last(url_or_id), "\\")[end][2:end]
        else
            user_input = split_backslash_last(url_or_id)
        end
    else
        user_input = url_or_id
    end
    return user_input, "1"
end

function process_artwork_url(url_or_id)
    if occursin("artworks", url_or_id)
        user_input = split(split_backslash_last(url_or_id), "\\")[begin]
    elseif occursin("illust_id", url_or_id)
        user_input = match(r"&illust_id.*", url_or_id)#[0].split("=")[-1]
    else
        user_input = url_or_id
    end
    return user_input, "2"
end

end
