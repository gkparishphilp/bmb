class Ebook < Asset
	has_attached :etext, :formats => ['html', 'doc', 'txt', 'rtf', 'epub', 'mobi', 'docx', 'odt', 'htm'], :private => true
end