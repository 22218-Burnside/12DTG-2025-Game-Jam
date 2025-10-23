# This script manages a continuous, shuffling music playlist using an AudioStreamPlayer.
extends Node

# --- Class Variables ---

# The name of the Audio Bus this player will use (set in Project Settings -> Audio Bus).
var bus = "music"
# Array to hold the resource paths (strings) of all music files.
var music_array = []
# Index of the song currently playing or about to be played in music_array.
var current_song = 0

# --- Constants ---

# Define the project folder path where music files are located.
# Note: "res://" is used for files inside the Godot project.
const MUSIC_FOLDER = "res://audio/music/"

# Define the valid music file extensions to filter for.
# These are the file types Godot can stream (.ogg, .mp3, etc.).
const MUSIC_EXTENSIONS = ["ogg", "mp3", "wav", "flac"]

# --- Built-in Functions ---

func _process(_delta: float) -> void:
	for player in get_children():
		player.volume_db = Settings.master_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	# 1. Setup the AudioStreamPlayer
	var music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Connect the 'finished' signal to the handler function.
	# The 'bind' method passes the music_player instance to the handler.
	music_player.finished.connect(_on_stream_finished.bind(music_player))
	music_player.bus = bus
	
	# 2. Populate the Playlist Array
	# Get the paths using the helper function and convert the PackedStringArray to a mutable Array.
	# Conversion is necessary as DirAccess returns a PackedStringArray.
	music_array = Array(get_music_file_paths(MUSIC_FOLDER, MUSIC_EXTENSIONS))
	
	
	# 3. Debug Output
	if not music_array.is_empty():
		print("Found music files:")
		for path in music_array:
			print("- " + path)
	else:
		print("No music files found in %s or directory could not be opened." % MUSIC_FOLDER)

	# 4. Shuffle and Start Playback
	# Randomize the order of the songs in the array.
	music_array.shuffle()
	
	# Start playing the first song (at index 0).
	play_next_song(music_player)

# --- Helper Functions ---

# Traverses a directory and returns a PackedStringArray of file paths matching the given extensions.
# Use type hints for readability, but standard variable naming conventions inside.
func get_music_file_paths(folder_path: String, extensions: PackedStringArray) -> PackedStringArray:
	var music_paths: PackedStringArray = []
	
	# Attempt to open the specified directory.
	var dir = DirAccess.open(folder_path)
	
	if dir:
		# Retrieve a list of file names (not including subdirectories).
		var files = dir.get_files()
		
		# Iterate through all found files.
		for file in files:
			# Get the file extension and convert it to lowercase for comparison.
			var ext = file.get_extension().to_lower()
			
			# Check if the file's extension is one of the valid music extensions.
			if ext in extensions:
				# Construct the full resource path (e.g., res://audio/music/song.ogg)
				var full_path = folder_path.path_join(file)
				music_paths.append(full_path)
	else:
		# Log an error if the directory access failed (e.g., path is incorrect).
		print("Error: Could not open directory at path: %s" % folder_path)
		
	return music_paths

# --- Signal Handler ---

# Connected to the AudioStreamPlayer's 'finished' signal.
func _on_stream_finished(music_player):
	# Immediately call the function to load and play the next track.
	play_next_song(music_player)

# --- Playback Logic ---

# Loads the next song in the playlist and starts playback.
# Functions use snake_case.
func play_next_song(music_player):
	# Load the AudioStream resource from the current song's path.
	# The 'load()' function is necessary here.
	music_player.stream = load(music_array[current_song])
	
	# Increment the song index for the next song.
	current_song += 1
	
	# Wrap the index back to 0 if we've reached the end of the playlist.
	# This creates a loop.
	if current_song >= music_array.size():
		current_song = 0
		
	# Begin playback of the newly loaded stream.
	music_player.play()
