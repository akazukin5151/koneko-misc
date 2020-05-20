import json
from koneko import api, utils

credentials, your_id = utils.config()
api.myapi.add_credentials(credentials)
api.myapi.start()

api.myapi.await_login()
mode1 = api.myapi.artist_gallery_request(2232374)
mode2 = api.myapi.protected_illust_detail(76695217)
mode3 = api.myapi.following_user_request(2232374, publicity='private', offset=0)
#mode4 = api.myapi.search_user_request('gomzi', offset=0)
#mode5 = api.myapi.illust_follow_request(restrict='private', offset=0)

with open('mode1.json', 'w') as f:
    json.dump(mode1, f)
with open('mode2.json', 'w') as f:
    json.dump(mode2, f)
with open('mode3.json', 'w') as f:
    json.dump(mode3, f)
#with open('mode4.json', 'w') as f:
#    json.dump(mode4, f)
#with open('mode5.json', 'w') as f:
#    json.dump(mode5, f)
