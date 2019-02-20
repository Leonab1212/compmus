spotify:user:1115668083:playlist:3pMfdAOvErb9AEnAO9W2fa


disney <- get_playlist_audio_features('128899670', '5NtjgKz4doejP5HJtKXFcS')

Sys.setenv(SPOTIFY_CLIENT_ID = 'ad25e68b1a5947f4bba994232e5c3923')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '52ee5a28706346a3b9a0840978e006fa')



spotify:track:6ocbgoVGwYJhOv1GgI9NsF


ornithology <- get_playlist_audio_features("1115668083", "3pMfdAOvErb9AEnAO9W2fa")
hhtm <- ornithology %>% filter(track_name != "Ornithology")
orni <- ornithology %>% filter(track_name == "Ornithology")