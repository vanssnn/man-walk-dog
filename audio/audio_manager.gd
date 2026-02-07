extends Node  # Changed from AudioStreamPlayer to Node

func play_music(music: AudioStream, volume = 0.0) -> void:
	# We create a dedicated player for music so it doesn't get deleted
	var music_player = get_node_or_null("MusicPlayer")
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicPlayer"
		music_player.bus = "Music"
		add_child(music_player)

	if music_player.stream == music:
		return
	
	music_player.stream = music    
	music_player.volume_db = volume
	music_player.play()

func play_sfx(stream: AudioStream, volume = 0.0, pitch_scale = 1.0):
	if stream == null: return
	
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = 'SFX' # Make sure you have a bus named 'SFX' in your Audio tab!
	sfx_player.volume_db = volume
	sfx_player.pitch_scale = pitch_scale
	add_child(sfx_player)
	sfx_player.play()
	
	# Clean up when done
	sfx_player.finished.connect(sfx_player.queue_free)
