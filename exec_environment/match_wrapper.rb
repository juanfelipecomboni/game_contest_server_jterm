#! /usr/bin/env ruby

#match_wrapper.rb
#Alex Sjoberg
#1/09/14


#TODO allow ref to specifiy a unique port for each player
# NOTE for testing arbitrary players and ref with the matchwrapper without having to worry about tournaments/daemons/etc, see wrapper_test.rb

#Imports
require 'socket'
require 'open-uri'
require 'timeout'

class MatchWrapper
    
    attr_accessor :results

    #Constructor, sets socket for communication to referee and starts referee and players
    def initialize(referee,number_of_players,max_match_time,players)  
        #Sets port for referee to talk to wrapper_server  
        @wrapper_server = TCPServer.new(0)
        @players = players
        @referee = referee.file_location
        @child_list = []
        @number_of_players = number_of_players
        @max_match_time = max_match_time
        @results = {}

    end

    def run_match
        #Start referee process, giving it the port to talk to us on
        wrapper_server_port = @wrapper_server.addr[1]
        @child_list.push(Process.spawn("#{@referee} -p #{wrapper_server_port} --num #{@number_of_players} & "))


        #Wait for referee to tell wrapper_server what port to start players on
        begin
            Timeout::timeout(3) do
                #Wait for referee to connect
                @ref_client = @wrapper_server.accept
                @client_port = nil #TODO is there a better way to wait for this?
                while @client_port.nil? #TODO error checking on returned port
                    @client_port = @ref_client.gets
                end
            end
        rescue Timeout::Error
            @results = "INCONCLUSIVE: Referee failed to provide a port!"  
            reap_children
            return
        end

        #Start players
        @players.each do |player|
            #Name must be given before port because it crashes for mysterious ("--name not found") reasons otherwise
            @child_list.push(Process.spawn("#{player.file_location} --name #{player.name} -p #{@client_port} "))
        end
        
        begin
            Timeout::timeout(@max_match_time) do
                self.wait_for_result
            end
        rescue Timeout::Error
            @results = "INCONCLUSIVE: Game exceeded allowed time!"
            reap_children
            return
        end
    end

    def wait_for_result
        @number_of_players.times do |i|
            individual_result = nil
            while individual_result.nil?
                individual_result = @ref_client.gets
            end
            individual_result = individual_result.split("|")
            player_name = individual_result[0]
            match_result = individual_result[1]
            player_score = individual_result[2].to_i
            @results[player_name] = {'result' => match_result , 'score' => player_score}
        end
    end
    
    #Reaping Children!!!!!
    ## TODO make sure children are always being reaped no matter what errors occur anywhere in the program. Currently this doesn't seem to be the case
    def reap_children
        @child_list.each do |pid|
            Process.kill('SIGKILL', pid)
        end
    end 
end

