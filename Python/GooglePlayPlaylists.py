# Docs
# https://unofficial-google-music-api.readthedocs.io/en/latest/

# TODO
# 1. Need to limit the number of songs added to a playlist to 1000

# Dependancies
# pip install gmusicapi

# Imports
from gmusicapi import Mobileclient
from winreg import *

# Retrieve Credentials - Credentials re stored as 2 string vales in HKLM\Software\Lattuce
hKey = OpenKey(HKEY_LOCAL_MACHINE, "Software\\Lattuce")
username = QueryValueEx(hKey, "GoogleUsername")[0]
password = QueryValueEx(hKey, "GooglePassword")[0]

# Log into Google
api = Mobileclient()
api.login(username, password, Mobileclient.FROM_MAC_ADDRESS) # => True

# Reactivate
# Delete Playlist
playlists = api.get_all_playlists()
for playlist in playlists:
	if playlist['name']=='Reactivate':
		id_to_delete = playlist['id']
		print('Deleting Playlist ID: ', id_to_delete)
		api.delete_playlist(id_to_delete)
# Add new Playlist
playlist_id = api.create_playlist('Reactivate')
songs = api.get_all_songs()
playlistsongs=[]
for song in songs:
	if 'Reactivate' in song['album']:
		print('Adding song ID: ', song['id'], 'to playlist Reactivate')		
		playlistsongs.append(song['id'])
api.add_songs_to_playlist(playlist_id, playlistsongs)

# Dance etc.
# Delete Playlist
playlists = api.get_all_playlists()
for playlist in playlists:
	if playlist['name']=='Dance':
		id_to_delete = playlist['id']
		print('Deleting Playlist ID: ', id_to_delete)
		api.delete_playlist(id_to_delete)
# Add new Playlist
playlist_id = api.create_playlist('Dance')
songs = api.get_all_songs()
playlistsongs=[]

for song in songs:
	if 'Dance' == song['genre'] or 'Big Room' == song['genre']  or 'Dance' == song['genre'] or 'Drum & Bass' == song['genre'] or 'Electronic' == song['genre'] or 'Electronica' == song['genre'] or 'Hard Dance' == song['genre'] or 'Hardcore' == song['genre'] or 'House' == song['genre'] or 'Progressive House' == song['genre'] or 'Psy-Trance' == song['genre'] or 'Rave' == song['genre'] or 'Tech House' == song['genre'] or 'Techno' == song['genre'] or 'Trance' == song['genre']:
		print('Adding song ID: ', song['id'], 'to playlist Dance')		
		playlistsongs.append(song['id'])
api.add_songs_to_playlist(playlist_id, playlistsongs)
