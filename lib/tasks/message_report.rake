namespace :message_report do
  task :statistics => :environment do
     require 'json'

    # ######  1)   numbers of the messages that sent and receive (remote and local).

         message_senders = Message.select("DISTINCT message_from")
         message_senders = Member.all
           if File.exist?("message_report1.txt")
             File.delete("message_report1.txt")
          end
          File.open("message_report1.txt" , "a+") do |file|
             file.write "1) Total number of the messages sent and received (both remote and local)."
             file.write "\n\n\n"
             file.write "---------------------------------------------------------------------------------------------------"
             file.write "\n\n"
             file.write "User\tMessages_Sent\tMessages_Received"
             file.write "\n\n"
             file.write "---------------------------------------------------------------------------------------------------"
             file.write "\n"
             total_msg_sent = 0
             total_msg_received = 0
            message_senders.each do |sender|
               messages_sent = Message.find_all_by_message_from(sender.name).count
               total_msg_sent += messages_sent
               messages_received =   Message.find_all_by_message_to(sender.name).count
               total_msg_received += messages_received
               file.write "#{sender.name}      \t#{messages_sent}\t#{messages_received}"
               file.write "\n"
            end
             file.write "---------------------------------------------------------------------------------------------------\n"
             file.write "Total      \t#{total_msg_sent}\t#{total_msg_received}"

              total_msg_received = 0
              total_msg_sent = 0





              ### 1 a) numbers of the messages that sent and receive remote
             file.write "\n \n \n \n"
             file.write "1 a) Total number of the messages that sent and received (Remote)\n\n"
             file.write "---------------------------------------------------------------------------------------------------"
             file.write "\n\n"
             file.write "User\t  messages_sent            messages_receive\n\n"
             file.write "---------------------------------------------------------------------------------------------------"
             file.write "\n"
             Member.all.each do |member|
               messages = Message.where("message_from = ? AND message_to != ? AND message_type = ?",member.name , member.name ,"sent")
               total_msg_sent += messages.length
               file.write "#{member.name}      \t#{messages.length}                   "
               messages1 = Message.where("message_from = ? AND message_to != ? AND message_type = ?" , member.name , member.name , "received")
               total_msg_received += messages1.length
               file.write "\t#{messages1.length}"
               file.write"\n"
             end
             file.write "---------------------------------------------------------------------------------------------------\n"
             #file.write "Total      \t#{total_msg_sent}\t#{total_msg_received}"
             file.write "Total      \t#{total_msg_sent}               \t#{total_msg_received}"




              ### 1 b) numbers of the messages that sent and receive local
                       total_msg_received = 0
                       total_msg_sent = 0
                       file.write "\n \n \n \n"
                       file.write "1 b) Total numbers of the messages that sent and receive (Local)\n\n"
                       file.write "---------------------------------------------------------------------------------------------------"
                       file.write "\n\n"
                       file.write "User\t  messages_sent            messages_receive\n"
                       file.write "\n"
                       file.write "---------------------------------------------------------------------------------------------------"
                       file.write "\n\n"
                       Member.all.each do |member|
                          messages = Message.where("message_from = ? AND message_to = ? AND message_type = ?",member.name , member.name ,"sent")
                          total_msg_sent += messages.length
                          file.write "#{member.name}      \t#{messages.length}                   "
                          messages1 = Message.where("message_from = ? AND message_to = ? AND message_type = ?" , member.name , member.name , "received")
                          total_msg_received += messages1.length
                         file.write "\t#{messages1.length}"
                         file.write"\n"
                       end
                       file.write "---------------------------------------------------------------------------------------------------\n"
                       file.write "Total      \t#{total_msg_sent}              \t#{total_msg_received}"



    ###########  2) number of profiles using SKB level 1
                 file.write "\n\n\n\n"
                 file.write "2) Total Number of profiles using SKB level 1"
                 file.write "\t:"
                 no_of_profile_using_skb_level1 = 0
                Member.all.each do |member|
                   isUsingskb1 = false
                  sent_messages = Message.where("message_from = ? AND message_type = ? AND created_at > ?" ,member.name , "sent" , 2.days.ago)
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
                file.write "#{no_of_profile_using_skb_level1}"
               # write into file   no_of_profile_using_skb_level1


    #########  3) numbers of users using level 2
                 file.write "\n\n\n\n"
                 file.write "3) Total Numbers of users using level 2"
                 file.write "\t:"
                no_of_profile_using_skb_level2 = 0
                Member.all.each do |member|
                  isUsingskb2 = false
                  sent_messages = Message.where("message_from = ? AND message_type = ? AND created_at > ?" ,member.name , "sent" , 2.days.ago)
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
               file.write "#{no_of_profile_using_skb_level2}"
    # write into file   no_of_profile_using_skb_level2

    ########## 4)  numbers of messages sent using SKB
                    file.write "\n\n\n\n"
                    file.write "4) Total Numbers of messages sent using SKB"
                    file.write "\t:"
                    no_of_messages_using_skb = 0
                    Message.all.each do |message|
                      message_json_array = JSON.parse(message.message)
                      message_json_array['message'].keys.each do |key|
                        if message_json_array['message']["#{key}"]['modeOfKeyboard'] == "SKB"
                          no_of_messages_using_skb = no_of_messages_using_skb + 1
                          break
                        end
                      end
                    end
                    file.write "#{no_of_messages_using_skb}"
                 #######  write into file no_of_messages_using_skb

    ########## 5)  number of messages were sent using qwerty keyboard.
                     file.write "\n\n\n\n"
                     file.write "5) Total Number of messages were sent using qwerty keyboard."
                     file.write "\t :"
                    no_of_messages_sent_using_Qkb = 0
                    Message.all.each do |message|
                       message_json_array = JSON.parse(message.message)
                       message_json_array['message'].keys.each do |key|
                           if message_json_array['message']["#{key}"]['modeOfKeyboard'] == "QKB"
                             no_of_messages_sent_using_Qkb  = no_of_messages_sent_using_Qkb  + 1
                             break
                           end
                       end
                    end
                  file.write "#{no_of_messages_sent_using_Qkb}"
                  file.write "\n\n"
                  puts "number of profiles using SKB level 1:    #{no_of_profile_using_skb_level1}"
                  puts "numbers of users using level 2:   #{no_of_profile_using_skb_level2}"
                  puts "numbers of messages sent using SKB:   #{no_of_messages_using_skb}"
                  puts "umber of messages were sent using qwerty keyboard:   #{no_of_messages_sent_using_Qkb}"


             no_of_symbols = 0
             symbols_with_qwerty = 0
             Message.all.each do |message|
               js = JSON.parse(message.message)
               js['message'].keys.each do |key|
                 if js['message']["#{key}"]['image'] != nil
                   no_of_symbols = no_of_symbols + 1
                 end
                 if  js['message']["#{key}"]['modeOfKeyboard'] == "QKB"  && js['message']["#{key}"]['image'] != nil
                   symbols_with_qwerty += 1
                 end
               end
             end
             puts "no_of_symbols: #{no_of_symbols}"
             puts "Average symbols in message : #{(no_of_symbols.to_f / Message.count).round(2)}"
             puts "symbols with qwerty : #{symbols_with_qwerty}"
             file.write "\n\n\n\n"
             file.write "6) Total Number of symbols used in messages"
             file.write "\t :"
             file.write "#{no_of_symbols}"
             file.write "\n\n\n\n"
             file.write "7) Average number of symbols used in messages"
             file.write "\t :"
             file.write "#{(no_of_symbols.to_f / Message.count).round(2)}"
             file.write "\n\n\n\n"
             file.write "8) Total Number of symbols with qwerty "
             file.write "\t :"
             file.write "#{symbols_with_qwerty}"

         end
     emails = ["satyen@motifworks.com", "nitin@motifworks.com", "sankar@motifworks.com", "satish@motifworks.com", "shechter@gmail.com", "ofir.harel@gmail.com", "ofir@olamundo.com"]

       emails.each do |email|
         UserMailer.welcome_email(email).deliver
       end



  end
end