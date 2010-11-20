class Pdf < Asset
	has_attached :pdf, :formats => ['pdf'], :private => true
end