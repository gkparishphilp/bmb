class AudioBook < Asset
	has_attached :audio, :formats => ['mp3', 'aac', 'wav', 'ogg'], :private => true
end