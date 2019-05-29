class CreateArtists < ActiveRecord::Migration[5.2]
   def change
      create_table :artists do |t|
         t.string :name
         t.string :genre
         t.string :website_url
      end
   end
end