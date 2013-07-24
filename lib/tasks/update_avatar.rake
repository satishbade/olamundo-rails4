namespace :update_avatar do
  task :from_dropbox => :environment do
    require 'open-uri'
    Dir.entries("/home/prabhanshu/avatars/avatars").each do |image_name|
     Member.all.each do |m|
       if m.avatar_file_name == image_name
         image_file = File.open("/home/prabhanshu/avatars/avatars/#{image_name}")
         m.update_attributes(:avatar => image_file)
         image_file.close
         image_url = m.avatar.url(:medium)
         m.update_attributes(:image_url => image_url)
       end
     end

    end
  end
 end