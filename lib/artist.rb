class Artist < ActiveRecord::Base
   has_many :concerts
   has_many :venues, through: :concerts

   # CLASS ***********************

   def self.artists_schedules_by_name(artist_name)
      Artist.all.select{|inst| inst.name == band_name}[0].my_schedule
   end

   def self.find_artist_by_email(email_address) #this method is used to check the email address for sign in in cli.rb
      self.where(["email = ?", email_address]).first
   end

   # def self.average_total_revenue
   #    will require the user and ticket classes
   # end

   # INSTANCE *******************

   def update_email(new_email)
      self.update(email: new_email)
   end

   def update_password(new_password)
      self.update(password: new_password)
   end

   def my_schedule #all concerts for artist
      Concert.all.select{|inst| inst.artist_id == self.id}
   end

   def my_schedule_info
      sched = {:gigs => []}
      self.my_schedule.each do |inst|
         # binding.pry
         #what is inst?
         sched[:gigs] << {name: inst.name, date: inst.date, venue: Venue.all.find{|i| i.id == inst.venue_id}.name}
      end
      puts sched
   end

   #concert status method:
   def concert_status_from_name(concert_name)
      a_concert = self.my_schedule.find{|concert| concert.name == concert_name}
      if a_concert
         a_concert.status
      else
         puts "there is no concert!"
      end
   end

   #1.
   def tickets_sold_concert(concert_name)#parameter is concert name
      event = self.my_schedule.find{|concert| concert.name == concert_name}
      # binding.pry
      #my_schedule calls all concerts for artist
      self.all_tickets_sold.select{|inst| inst.concert_id == event.id}
   end

   def number_tickets_sold_concert(concert) #from artist portal cli, called for ticket count
      puts tickets_sold_concert(concert).count
   end



   def all_tickets_sold #called by 1.
      events = self.my_schedule.map{|inst| inst.id}.uniq
      Ticket.all.select{|inst| events.include?(inst.concert_id)}
   end

   def total_number_tickets_sold
      puts self.all_tickets_sold.count
   end
   
   def where_am_i_playing #method to show an artist where their concert names, locations and capacities
      venues = self.my_schedule.map{|inst| inst.venue_id}
      objects = Venue.all.select{|inst| venues.include?(inst.id)}
      list = objects.map{|inst| "#{inst.name} - #{inst.location} - #{inst.capacity}"}
      puts list
   end
   
   def my_ticket_prices(concert_name)
      self.my_schedule.find{|inst| inst.name == concert_name}.price
   end

   def list_my_ticket_prices(concert_name)
      puts "£#{my_ticket_prices(concert_name)}"
   end

   def my_earnings_concert(concert_name)
      # assume 25% for artists 
      self.my_ticket_prices(concert_name)*self.tickets_sold_concert(concert_name).count*0.25
   end

   def my_earnings_concert_gbp(concert_name)
      # assume 25% for artists 
      puts "£#{my_earnings_concert(concert_name)}"
   end

   def my_total_earnings
      a = self.my_schedule.map(&:name).collect{|inst| my_earnings_concert(inst)}.inject(0){|sum, x| sum+x}
      puts "£#{a}"
   end

end
