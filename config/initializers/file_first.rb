Paperclip.interpolates('file_name') do |attachment, style|
  attachment.original_filename.first.capitalize
end