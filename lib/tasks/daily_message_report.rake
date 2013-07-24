namespace :new_message_report do
  task :statistics => :environment do
    require 'json'
    #require 'ftools'
    # ######  1)   numbers of the messages that sent and receive (remote and local).
    # /home/prabhanshu/Projects/git_local/olamundo/app/views/user_mailer/welcome_email.text.erb
    message_senders = Message.select("DISTINCT message_from")
    message_senders = Member.all
    if File.exist?("#{Rails.root}/app/views/user_mailer/welcome_email.html.erb")
       File.delete("#{Rails.root}/app/views/user_mailer/welcome_email.html.erb")
    end
    File.open("#{Rails.root}/app/views/user_mailer/welcome_email.html.erb" , "a+") do |file|
      file.puts "<html><head>"
      file.puts"</head><body>"
      file.puts "1) Total number of the messages sent and received (both remote and local aggregate)."
      file.puts "<table>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>User</td><td style='font-weight:bold;'>MessageSent</td><td style='font-weight:bold;'>MessageReceived</td></tr>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      total_msg_sent = 0
      total_msg_received = 0
      message_senders.each do |sender|
        #messages_sent = Message.find_all_by_message_from(sender.name).count
        messages_sent = Message.where("message_from = ? " , sender.name).count
        total_msg_sent += messages_sent
        #messages_received =   Message.find_all_by_message_to(sender.name).count
        messages_received = Message.where("message_to = ? " , sender.name).count
        total_msg_received += messages_received
        file.puts"<tr><td>#{sender.name}</td><td style='text-align:center;'>#{messages_sent}</td><td style='text-align:center;'>#{messages_received}</td></tr>"
        #  for i in 1..(27 - sender.name.length)
        #    file.putc " "
      end
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>Total</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_sent}</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_received}</td></tr>"
      file.puts "</table>"

      file.puts "<br/>"
      file.puts "1 a) Total number of the messages sent and received (Remote aggregate)."
      file.puts "<table>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>User</td><td style='font-weight:bold;'>MessageSent</td><td style='font-weight:bold;'>MessageReceived</td></tr>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      total_msg_sent = 0
      total_msg_received = 0
      Member.all.each do |sender|
        #messages_sent = Message.find_all_by_message_from(sender.name).count
        messages_sent = Message.where("message_from = ? AND message_to != ? AND message_type = ?" , sender.name , sender.name , "sent").count
        total_msg_sent += messages_sent
        #messages_received =   Message.find_all_by_message_to(sender.name).count
        messages_received = Message.where("message_to = ? AND message_from != ? AND message_type = ?" , sender.name , sender.name , "received").count
        total_msg_received += messages_received
        file.puts"<tr><td>#{sender.name}</td><td style='text-align:center;'>#{messages_sent}</td><td style='text-align:center;'>#{messages_received}</td></tr>"
        #  for i in 1..(27 - sender.name.length)
        #    file.putc " "
      end
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>Total</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_sent}</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_received}</td></tr>"
      file.puts "</table>"

      file.puts "<br/>"
      file.puts "1 b) Total number of the messages sent and received (Local aggregate)."
      file.puts "<table>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>User</td><td style='font-weight:bold;'>MessageSent</td><td style='font-weight:bold;'>MessageReceived</td></tr>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      total_msg_sent = 0
      total_msg_received = 0
      Member.all.each do |sender|
        #messages_sent = Message.find_all_by_message_from(sender.name).count
        messages_sent = Message.where("message_from = ? AND message_to = ? AND message_type = ?" , sender.name , sender.name , "sent").count
        total_msg_sent += messages_sent
        #messages_received =   Message.find_all_by_message_to(sender.name).count
        messages_received = Message.where("message_to = ? AND message_from = ? AND message_type = ?" , sender.name , sender.name , "received").count
        total_msg_received += messages_received
        file.puts"<tr><td>#{sender.name}</td><td style='text-align:center;'>#{messages_sent}</td><td style='text-align:center;'>#{messages_received}</td></tr>"
        #  for i in 1..(27 - sender.name.length)
        #    file.putc " "
      end
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>Total</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_sent}</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_received}</td></tr>"
      file.puts "</table>"

      file.puts "2) Total number of the messages sent and received (both remote and local)  on Date: #{Date.today}"
      file.puts "<table>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>User</td><td style='font-weight:bold;'>MessageSent</td><td style='font-weight:bold;'>MessageReceived</td></tr>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"

      total_msg_sent = 0
      total_msg_received = 0
      message_senders.each do |sender|
        #messages_sent = Message.find_all_by_message_from(sender.name).count
        messages_sent = Message.where("message_from = ? AND created_at > ?" , sender.name ,1.days.ago).count
        total_msg_sent += messages_sent
        #messages_received =   Message.find_all_by_message_to(sender.name).count
        messages_received = Message.where("message_to = ? AND created_At > ?" , sender.name , 1.days.ago).count
        total_msg_received += messages_received
         file.puts"<tr><td>#{sender.name}</td><td style='text-align:center;'>#{messages_sent}</td><td style='text-align:center;'>#{messages_received}</td></tr>"
      #  for i in 1..(27 - sender.name.length)
      #    file.putc " "
        end
    #  #
    #  #  file.puts"#{messages_sent}"
    #  #  messages_sent = messages_sent.to_s
    #  #  for i in 1..(35 - messages_sent.length )
    #  #    file.putc " "
    #  #  end
      #  file.puts "#{messages_received }"
      #
      #end
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>Total</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_sent}</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_received}</td></tr>"
      file.puts "</table>"


      total_msg_received = 0
      total_msg_sent = 0
      file.puts"<br/><br/><br/>"
      file.puts " 2 a) numbers of the messages that sent and receive remote on Date: #{Date.today} "
      file.puts "<table>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>User</td><td style='font-weight:bold;'>MessageSent</td><td style='font-weight:bold;'>MessageReceived</td></tr>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      Member.all.each do |member|
        messages = Message.where("message_from = ? AND message_to != ? AND message_type = ? AND created_at > ?",member.name , member.name ,"sent" , 1.days.ago)
        total_msg_sent += messages.length
        messages1 = Message.where("message_from = ? AND message_to != ? AND message_type = ? AND created_at > ? " , member.name , member.name , "received" , 1.days.ago)
        total_msg_received += messages1.length
        file.puts"<tr><td>#{member.name}</td><td style='text-align:center;'>#{messages.length}</td><td style='text-align:center;'>#{messages1.length}</td></tr>"
      end
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>Total</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_sent}</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_received}</td></tr>"
      file.puts "</table>"


      total_msg_received = 0
      total_msg_sent = 0
      file.puts"<br/><br/><br/>"
      file.puts " 2 b) numbers of the messages that sent and receive remote (local) on Date: #{Date.today}"
      file.puts "<table>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>User</td><td style='font-weight:bold;'>MessageSent</td><td style='font-weight:bold;'>MessageReceived</td></tr>"
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      Member.all.each do |member|
        messages = Message.where("message_from = ? AND message_to = ? AND message_type = ? AND created_at > ?",member.name , member.name ,"sent" , 1.days.ago)
        total_msg_sent += messages.length
        messages1 = Message.where("message_from = ? AND message_to = ? AND message_type = ? AND created_at > ? " , member.name , member.name , "received" , 1.days.ago)
        total_msg_received += messages1.length
        file.puts"<tr><td>#{member.name}</td><td style='text-align:center;'>#{messages.length}</td><td style='text-align:center;'>#{messages1.length}</td></tr>"
      end
      file.puts "<tr><td><hr></td><td><hr></td><td><hr></td></tr>"
      file.puts "<tr><td style='font-weight:bold;'>Total</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_sent}</td><td style='text-align:center;font-weight:bold;'>     #{total_msg_received}</td></tr>"
      file.puts "</table>"


      ############  2) number of profiles using SKB level 1
      file.puts "<br/><br/><br/>"
      no_of_profile_using_skb_level1 = 0
      Member.all.each do |member|
        isUsingskb1 = false
        sent_messages = Message.where("message_from = ? AND message_type = ? AND created_at > ?" ,member.name , "sent" , 1.days.ago)
        sent_messages.each do |sent_message|
          message_json = JSON.parse(sent_message.message)
          message_json['message'].keys.each do |key|
            if message_json['message']["#{key}"]['skbLevel'] == "1"
              no_of_profile_using_skb_level1 = no_of_profile_using_skb_level1 + 1
              isUsingskb1 = true
              break
            end
          end
          if isUsingskb1 == true
            break
          end
          #if (message_json['message']['1']['skbLevel'] == 1)
          #  no_of_profile_using_skb_level1 = no_of_profile_using_skb_level1 + 1
          #  break
          #end
        end
      end
      file.puts "3) Total Number of profiles using SKB level 1 on Date - #{Date.today}:    #{no_of_profile_using_skb_level1}"
      ## write into file   no_of_profile_using_skb_level1

      ##########  3) numbers of users using level 2
      file.puts "<br/><br/><br/>"


      no_of_profile_using_skb_level2 = 0
      Member.all.each do |member|
        isUsingskb2 = false
        sent_messages = Message.where("message_from = ? AND message_type = ? AND created_at > ?" ,member.name , "sent" , 1.days.ago)
        sent_messages.each do |sent_message|
          message_json = JSON.parse(sent_message.message)
          message_json['message'].keys.each do |key|
            if message_json['message']["#{key}"]['skbLevel'] == "2"
              no_of_profile_using_skb_level2 = no_of_profile_using_skb_level2 + 1
              isUsingskb2 = true
              break
            end
          end
          if isUsingskb2 == true
            break
          end
          #if (message_json['message']['1']['skbLevel'] == 2)
          #   no_of_profile_using_skb_level2 = no_of_profile_using_skb_level2 + 1
          #   break
          #end
        end
      end
      file.puts "4) Total Numbers of users using level 2 on Date - #{Date.today}:    #{no_of_profile_using_skb_level2}"
      ## write into file   no_of_profile_using_skb_level2
      #
      ########### 4)  numbers of messages sent using SKB
      file.puts "<br/><br/><br/>"
      no_of_messages_using_skb = 0
      Message.where("created_at > ?" , 1.days.ago).each do |message|
        message_json_array = JSON.parse(message.message)
        message_json_array['message'].keys.each do |key|
          if message_json_array['message']["#{key}"]['modeOfKeyboard'] == "SKB"
            no_of_messages_using_skb = no_of_messages_using_skb + 1
            break
          end
        end
      end
      file.puts "5) Total Numbers of messages sent using SKB on Date - #{Date.today}:    #{no_of_messages_using_skb}"
      ########  write into file no_of_messages_using_skb
      #
      ########### 5)  number of messages were sent using qwerty keyboard.
      file.puts "<br/><br/><br/>"
      no_of_messages_sent_using_Qkb = 0
      Message.where("created_at > ?" , 1.days.ago).each do |message|
        message_json_array = JSON.parse(message.message)
        message_json_array['message'].keys.each do |key|
          if message_json_array['message']["#{key}"]['modeOfKeyboard'] == "QKB"
            no_of_messages_sent_using_Qkb  = no_of_messages_sent_using_Qkb  + 1
            break
          end
        end
      end
      file.puts "6) Total Number of messages were sent using qwerty keyboard on Date - #{Date.today}:    #{no_of_messages_sent_using_Qkb}"
      file.puts "</body></html>"
    end


    #source_file = "/home/prabhanshu/Projects/git_local/olamundo/message_report.txt"
    #target_file = "/home/prabhanshu/Projects/git_local/olamundo/app/views/user_mailer/welcome_email.html.erb"
    #File.copy source_file, target_file

    #emails = ["satyen@motifworks.com", "nitin@motifworks.com", "sankar@motifworks.com", "satish@motifworks.com", "shechter@gmail.com", "ofir.harel@gmail.com", "ofir@olamundo.com"]
    emails = [ "prabhanshu@motifworks.com" ,"avinash@motifworks.com","satish@motifworks.com", "satyen@motifworks.com", "sankar@motifworks.com", "nitin@motifworks.com", "shechter@gmail.com", "ofir.harel@gmail.com", "ofir@olamundo.com" ]

    emails.each do |email|
      UserMailer.welcome_email(email).deliver
    end



  end
end