#require 'rubygems'
#require 'right_aws'
#
#aws_access_key_id = 'AKIAJPWQVF5DUCXGNDNA'
#aws_secret_access_key = '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'
#target_bucket = 'amazon-olamundo-dev'
#destination_bucket = 'olamund-amazon-dev'
#
#s3 = RightAws::S3Interface.new(aws_access_key_id, aws_secret_access_key)
#
#copied_keys = Array.new
#s3.incrementally_list_bucket(destination_bucket) do |key_set|
#  copied_keys << key_set[:contents].map{|k| k[:key]}.flatten
#end
#copied_keys.flatten!
#
#s3.incrementally_list_bucket(target_bucket) do |key_set|
#  key_set[:contents].each do |key|
#    key = key[:key]
#    if copied_keys.include?(key)
#      puts "#{destination_bucket} #{key} already exists. Skipping..."
#    else
#      puts "Copying #{target_bucket} #{key}"
#
#      retries=0
#      begin
#        s3.copy(target_bucket, key, destination_bucket)
#      rescue Exception => e
#        puts "cannot copy key, #{e.inspect}\nretrying #{retries} out of 10 times..."
#        retries += 1
#        retry if retries <= 10
#      end
#    end
#  end
#end